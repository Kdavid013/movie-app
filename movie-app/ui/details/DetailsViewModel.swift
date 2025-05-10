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
    
    
    let movieIdSubject = PassthroughSubject<Int, Never>()
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        print("<<<details ini running")
        
        movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchDetailRequest(movieId: movieId)
                return self.service.fetchMovieDetail(req: requset)
            }
            .receive(on: RunLoop.main)
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
                
            } receiveValue: { [weak self] movie in
                self?.movie = movie
            }
            .store(in: &cancellables)
        
    }
    
    
}
