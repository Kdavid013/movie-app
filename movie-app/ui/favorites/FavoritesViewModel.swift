//
//  FavoritesViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

class FavoritesViewModel: ErrorPresentable, ObservableObject {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var favoriteMediaStorage: FavoriteMediaStoreProtocol
    
    init() {
        viewLoaded
            .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.service.fetchFavorites(req: FetchFavoritesRequest(), fromLocal: true)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
