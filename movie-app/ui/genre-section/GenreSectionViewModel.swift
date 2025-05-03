//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

protocol ErrorViewModelProtocol{
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol{
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    //    private var movieService: MovieServiceProtocol = MovieService()
    @Inject var movieService: MovieServiceProtocol
    
    //    func fetchGenres() async{
    //       do {
    //           let request = FetchGenreRequest()
    //           let genres = Environment.name  == .tv ? try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
    //       visszahozza a programot a main threadre, hogy ne blokkolja a UI-t
    //           DispatchQueue.main.async {
    //               self.genres = genres
    //           }
    //       }
    //       catch let error as MovieError
    //       {
    //           DispatchQueue.main.async {
    //               self.alertModel = self.toAlertModel(error)
    //           }
    //       } catch{
    //           DispatchQueue.main.async {
    //               self.alertModel = self.toAlertModel(error)
    //           }
    //       }
    //    }
    
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
    
    init() {
    
            let request = FetchGenreRequest()
            
        
        //        future publisher, ami genre kat ad ki egy tömbben
        let future = Future<[Genre], Error> { [self] future in
            Task {
                do {
                    if Environment.name == .tv
                        {
                        let genres = try await self.movieService.fetchTVGenres(req: request)
                        future(.success(genres))
                    }else{
                        let genres = try await self.movieService.fetchGenres(req: request)
                        future(.success(genres))
                    }
//                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
//        let futureTV = Future<[Genre], Error> { future in
//            Task {
//                do {
//                    let genres = try await self.movieService.fetchTVGenres(req: request)
//                    future(.success(genres))
//                } catch {
//                    future(.failure(error))
//                }
//            }
//        }
        
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
            } receiveValue: {[weak self] genres in
                self?.genres = genres
            }
            .store(in: &cancellables)
    }
    
    //    init() {
    //            let request = FetchGenreRequest()
    //
    //            let publisher = PassthroughSubject<[Genre], Error>()
    //
    //            Task {
    //                do {
    //                    let genres = try await self.movieService.fetchTVGenres(req: request)
    //                    publisher.send(genres)
    //                    publisher.send(completion: .finished) // FONTOS: befejezés
    //                } catch {
    //                    publisher.send(completion: .failure(error)) // Hiba küldése
    //                }
    //            }
    //
    //            publisher
    //                .receive(on: RunLoop.main)
    //                .sink { completion in
    //                    switch completion {
    //                    case .failure(let error):
    //                            self.alertModel = self.toAlertModel(error)
    //                    case .finished:
    //                            break
    //                    }
    //                } receiveValue: { genres in
    //                    self.genres = genres
    //                }
    //                .store(in: &cancellables)
    //        }
}
