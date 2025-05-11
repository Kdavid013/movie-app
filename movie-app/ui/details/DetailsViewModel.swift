//
//  DetailsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailsViewModelProtocol: ObservableObject {
    var movie: MediaItemDetail { get }
    
}

class DetailsViewModel: DetailsViewModelProtocol, ErrorPresentable {
    
    @Published var movie: MediaItemDetail = MediaItemDetail()
    @Published var people: [CompanyAndCast] = []
    
    
    let movieIdSubject = PassthroughSubject<Int, Never>()
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        print("<<<details ini running")
        
        
        let details = movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchDetailRequest(movieId: movieId)
                return self.service.fetchMovieDetail(req: requset)
            }
        
        let cast = movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<[CompanyAndCast], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchDetailRequest(movieId: movieId)
                return self.service.fetchMovieCredits(req: requset)
            }
        
//        
        details.combineLatest(cast)
            .receive(on: RunLoop.main)
            .print("<<< DEBUG: details combineLatest")
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
                    
            } receiveValue: { [weak self] movie, cast in
                self?.people = cast
                self?.movie = movie
            }
            .store(in: &cancellables)
    }
    
    
}
