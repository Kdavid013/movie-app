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
    var movies: [Movie] { get }
    
}

class FavoritesViewModel: FavoritesViewModelProtocol {
    @Published var movies: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    @Inject var movieService: MovieServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    private func toAlertModel(_ error: Error) -> AlertModel{
        guard let error = error as? MovieError else{
            return AlertModel(
                title: "alert.unexpected.title",
                message: "alert.unexpected.text",
                dismissButtonTitle: "alert.dismiss.button"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "alert.api.title",
                message: message,
                dismissButtonTitle: "alert.dismiss.button"
            )
        case .clientError:
            return AlertModel(
                title: "Client Error",
                message: error.localizedDescription,
                dismissButtonTitle: "alert.dismiss.button"
            )
        default:
            return AlertModel(
                title: "alert.unexpected.title",
                message: "alert.unexpected.text",
                dismissButtonTitle: "alert.dismiss.button"
            )
        }
    }
    
    init(){
        let request = FetchMoviesRequest(genreId: 28)
        
        //        future publisher, ami genre kat ad ki egy tömbben
        let future = Future<[Movie], Error> { future in
            Task {
                do {
                    let movies = try await self.movieService.fetchFavorites(req: request)
                    future(.success(movies))
                } catch {
                    future(.failure(error))
                }
            }
            
        }
            future
                .receive(on: RunLoop.main)
            //        completion blokk megvizsgáljuk a sink válasza milyen tipusu
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        self.alertModel = self.toAlertModel(error)
                    case .finished:
                        break
                    }
                } receiveValue: {[weak self] movies in
                    self?.movies = movies
                }
                .store(in: &cancellables)
        }
    }


