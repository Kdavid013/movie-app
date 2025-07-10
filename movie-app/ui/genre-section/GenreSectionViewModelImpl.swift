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
    @Published var motdMovie: MediaItemDetail = MediaItemDetail()
    @Published var motdMovies: [MediaItemDetail] = []
    
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
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .map( { mediaItemPage in
                Array(mediaItemPage.mediaItems.prefix(3))
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
    
    func getMotdMovies(){
        for _ in 0..<5{
            getRandomMovies(genreId: nil)
        }
    }
    
    func getRandomMovies(genreId: Int?) {
        useCase.loadMediaItems(genreId: genreId)
            .flatMap { mediaItemPage -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let randomMovie = mediaItemPage.mediaItems.shuffled().first else{
                    return Fail(error: MovieError.clientError)
                        .eraseToAnyPublisher()
                }
                return self.useCase.loadMotdMovie(movie: randomMovie)
            }
            .sink { completion in
                print("Completion: \(completion)")
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { item in
                self.motdMovies.append(item)
                
                self.indexChanger(state: true)
            }
            .store(in: &cancellables)
    }
    
    
    func indexChanger(state: Bool = false){
        
        guard indexChangerCancellable == nil else { return }
        
        let movieCount = motdMovies.count
        guard movieCount > 0 else { return }
        
        indexChangerCancellable = Array(0..<movieCount).publisher
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
            })
    }
    
    func reappearChanges(){
        self.mediaItemsByGenre.removeAll()
        self.loadGenres()
        self.genreAppeared()
        self.motdMovies.removeAll()
        self.getMotdMovies()
       
    }
    
    func stopIndexChanger(){
        indexChangerCancellable?.cancel()
        indexChangerCancellable = nil
    }
}
