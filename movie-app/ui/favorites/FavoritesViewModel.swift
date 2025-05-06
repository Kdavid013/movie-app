//
//  FavoritesViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

protocol FavoritesViewModelProtocol: ObservableObject {
    var movies: [MediaItem] { get }
    
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPresentable {
    
    @Published var movies: [MediaItem] = []
    var alertModel: AlertModel? = nil
    
    @Inject
    var service: ReactiveMoviesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    init(){
        //        let request = FetchFavoritesRequest()
        
        let request = FetchFavoritesRequest()
        service.fetchFavorites(req: request)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: {[weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
        
    }
}
