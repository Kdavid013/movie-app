//
//  GenreSectionUseCase.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 27..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol GenreSectionUseCase {
    func loadGenres() -> AnyPublisher<[Genre], MovieError>
    var showAppearPopup: AnyPublisher<Bool, Never> { get }
    func genresAppeared()
    func loadMediaItems(genreId: Int) -> AnyPublisher<[MediaItem], MovieError>
}

class GenreSectionUseCaseImpl: GenreSectionUseCase {
    
    @Inject
    private var repository: MovieRepository
    
    private var appearCounter = 0
    
    private var appearSubject = CurrentValueSubject<Int, Never>(0)
    
    var showAppearPopup: AnyPublisher<Bool, Never>{
        appearSubject.map{ counter in
            counter == 3
        }
        .eraseToAnyPublisher()
    }
    
    func genresAppeared() {
        appearCounter += 1
        appearSubject.send(appearCounter)
    }
    
    func loadGenres() -> AnyPublisher<[Genre], MovieError> {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.repository.fetchTVGenres(req: request):
        self.repository.fetchGenres(req: request)
        
        return genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .eraseToAnyPublisher()
    }
    
    func loadMediaItems(genreId: Int) -> AnyPublisher<[MediaItem], MovieError> {
        
        let request = FetchMoviesRequest(genreId: genreId)
        return Environments.name == .tv ?
        self.repository.fetchSeries(req: request):
        self.repository.fetchMovies(req: request)
    }
}

