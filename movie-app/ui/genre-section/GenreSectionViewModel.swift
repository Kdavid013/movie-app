//
//  GenreSectionViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper

protocol ErrorViewModelProtocol{
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModelProtocol: ObservableObject {
    var genres: [Genre] { get }
    func fetchGenres() async
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol{
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
//    private var movieService: MovieServiceProtocol = MovieService()
    @Inject var movieService: MovieServiceProtocol
    
    func fetchGenres() async{
       do {
           let request = FetchGenreRequest()
           let genres = Environment.name  == .tv ? try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
//         visszahozza a programot a main threadre, hogy ne blokkolja a UI-t
           DispatchQueue.main.async {
               self.genres = genres
           }
       }
       catch let error as MovieError
       {
           DispatchQueue.main.async {
               self.alertModel = self.toAlertModel(error)
           }
       } catch{
           DispatchQueue.main.async {
               self.alertModel = self.toAlertModel(error)
           }
       }
    }
    
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
}
