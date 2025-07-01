//
//  CastDetailsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 09..
//

import Foundation
import InjectPropertyWrapper
import Combine

enum CastDetailType{
    var id: Int {
        switch self{
        case .castMember(id: let id):
            return id
        case .company(id: let id):
            return id
        }
    }
    case castMember(id: Int)
    case company(id: Int)
}

class CastDetailsViewModel: ObservableObject, ErrorPresentable{
    
    @Published var castDetail: CastDetail = CastDetail()
    @Published var alertModel: AlertModel? = nil
    @Published var rating: Int = 0
    @Published var combinedCredits: [MediaItem] = []
    
    let participantTypeSubject = PassthroughSubject<CastDetailType, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
        let combinedCredits = participantTypeSubject
            .flatMap { [weak self] participantType -> AnyPublisher<[MediaItem], MovieError> in
                print(">>>Emitting participantType: \(participantType)")
                guard let self = self else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                    
                }
                let request = FetchDetailRequest(movieId: participantType.id)
                
                return self.repository.fetchCombinedCredits(req: request)
            }
        
        let participantDetail = participantTypeSubject
            .flatMap { [weak self] participantType -> AnyPublisher<CastDetail, MovieError> in
                guard let self = self else {
                    return Fail(error: MovieError.unexpectedError).eraseToAnyPublisher()
                }
                let request = FetchDetailRequest(movieId: participantType.id)
                
                switch participantType {
                case .castMember:
                    return self.repository.fetchCastDetail(req: request)
                case .company:
                    return self.repository.fetchCompanyDetail(req: request)
                }
                
            }
        
        combinedCredits
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    print(">>>Error received: \(error)")
                }
            }, receiveValue: { [weak self] combinedCredits in
                print(">>>Received combinedCredits: \(combinedCredits)")
                self?.combinedCredits.append(contentsOf: combinedCredits)
//                self?.castDetail = castDetail
//                
//                self?.rating = self?.calculateStarRating(for: castDetail.popularity) ?? 0
            })
            .store(in: &cancellables)
        
        participantDetail
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }, receiveValue: { [weak self] castDetail in
                print("<<<<",castDetail)
//                self?.combinedCredits = combinedCredits
                self?.castDetail = castDetail
                self?.rating = self?.calculateStarRating(for: castDetail.popularity) ?? 0
            })
            .store(in: &cancellables)
        
    }
    
    private func calculateStarRating(for popularity: Double?) -> Int {
        guard let popularity = popularity else { return 0 }
        if popularity == 0 {
            return 0
        }
        
        let maxPopularity = 30.0 // Adjusted maximum for better scaling
        let scaledPopularity = min(popularity, maxPopularity)
        
        // Scale to a 0-4 range and add 1, so the minimum is 1 star
        let rating = (scaledPopularity / maxPopularity) * 4.0
        
        return Int(rating + 1.0)
    }
}
