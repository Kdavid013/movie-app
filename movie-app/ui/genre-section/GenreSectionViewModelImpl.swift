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

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    func loadGenres()
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorViewModelProtocol, ErrorPresentable{
    @Published var genres: [Genre] = []
    @Published var mediaItemsByGenre: [Int: [MediaItem]] = [:]
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    var repository: MovieRepository
    
    @Inject
    var useCase: GenreSectionUseCase
    
    init() {
        useCase.showAppearPopup
            .map{ showAppearPopup -> AlertModel? in
                if showAppearPopup{
                    return AlertModel(title:"Értékeld az appot", message: "Értékeld az appot", dismissButtonTitle: "Rendben")
                }
                return nil
            }
            .sink { [weak self] alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
    }
    
    func debugPrint() {
        print("<<<<megjelent")
    }
    
    func loadGenres() {
        useCase.loadGenres()
//            .map({genres in
//                Array(genres.prefix(5))
//            })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func loadMediaItems(genreId: Int) {
    
        
        
        useCase.loadMediaItems(genreId: genreId)
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .map({mediaItems in
            Array(mediaItems.prefix(5))
        })
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItems in
                self.mediaItemsByGenre[genreId] = mediaItems
            }
            .store(in: &cancellables)
    }
    
    func genreAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItemsByGenre(_ genreId: Int) -> [MediaItem] {
        return self.mediaItemsByGenre[genreId] ?? Array(repeating: MediaItem(), count: 5)
    }
}
