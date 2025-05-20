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

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorViewModelProtocol, ErrorPresentable{
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject var service: ReactiveMoviesServiceProtocol
    
    
    init() {
            let request = FetchGenreRequest()
            
            let genres = Environments.name == .tv ?
            self.service.fetchTVGenres(req: request):
            self.service.fetchGenres(req: request)
            
        genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .print("<<<debug")
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
        }
    
}
