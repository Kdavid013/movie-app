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
    @Published
    var onScreenIndex: Int = 0
    
    private var cancellables = Set<AnyCancellable>()
    @Published var motdMovies: [MediaItemDetail]? = [] ?? Array(repeating: MediaItemDetail(), count: 5)
    
    //    @Published var onScreenIndex: Int = 0
    
    var randomMoviesSubject: [AnyPublisher<MediaItemDetail, MovieError>] = []
    
    private var indexChangerCancellable: AnyCancellable?
    
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
        
        self.getRandomMovies(genreId: nil)
      
        self.indexChanger()
    }
    
    func loadGenres() {
        
        print("<<< genre lekérés lefutott")
        
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
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItemPage in
                self.mediaItemsByGenre[genreId] = mediaItemPage.mediaItems
            }
            .store(in: &cancellables)
    }
    
    func genreAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItemsByGenre(_ genreId: Int) -> [MediaItem] {
        return self.mediaItemsByGenre[genreId] ?? Array(repeating: MediaItem(), count: 5)
    }
    
    func getRandomMovies(genreId: Int?) {
        
        print("<<< lefutott a film választés")
      
        useCase.loadMediaItems(genreId: genreId)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItemPage in
                
                if self.motdMovies?.count ?? 0 < 5{
                    let randomMovies = mediaItemPage.mediaItems.shuffled().prefix(5)
                    
                    randomMovies.flatMap{ movie in
                        self.useCase.loadMotdMovie(movie: movie)
                            .sink { completion in
                                if case let .failure(error) = completion {
                                    self.alertModel = self.toAlertModel(error)
                                }
                            } receiveValue: { mediaItemDetail in
                                self.motdMovies?.append(mediaItemDetail)
//                                print("<<debug receive", self.motdMovies?.count)
                            }
                            .store(in: &self.cancellables)
                    }
                }
//                print("<<debug", self.motdMovies?.count)
            }
            .store(in: &cancellables)
    }
    
    func getRandomMovies2(genreId: Int?) {
        
//        useCase.loadMediaItems(genreId: genreId)
//            .flatMap({ mediaItemPage -> AnyPublisher<[MediaItemDetail], MovieError> in
//                let randomMovies = mediaItemPage.mediaItems.shuffled().prefix(5)
//                
//               let collection = randomMovies.flatMap{ movie -> AnyPublisher<MediaItemDetail, MovieError> in
//                    self.useCase.loadMotdMovie(movie: movie)
//                        
//                }
//        
//            })
//            .collect()
//            .sink { completion in
//                if case let .failure(error) = completion {
//                    self.alertModel = self.toAlertModel(error)
//                }
//            } receiveValue: { items in
//                let array = items.flatMap { $0 }
//                self.motdMovies?.append(contentsOf: array)
//            }
//            .store(in: &cancellables)
    }
    
    func indexChanger(state: Bool = false){
        
        guard indexChangerCancellable == nil else { return }
        
        indexChangerCancellable = [0,1,2,3,4].publisher
            .flatMap(maxPublishers: .max(1)) {
                Just($0).delay(for: .seconds(2), scheduler: RunLoop.main)
            }
            .sink (receiveCompletion: { completion in
                if case .finished = completion {
                    self.indexChangerCancellable = nil
                    self.indexChanger()
                }
            }, receiveValue: { [weak self] index in
                
                
                self?.onScreenIndex = index
                
                print("<<<",index)
            })
            
    }
    
    func stopIndexChanger(){
        indexChangerCancellable?.cancel()
        indexChangerCancellable = nil
    }
}
