//
//  DetailsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//

import Foundation
import InjectPropertyWrapper
import Combine

protocol DetailsViewModelProtocol: ObservableObject {
    var movie: MediaItemDetail { get }
}

class DetailsViewModel: DetailsViewModelProtocol, ErrorPresentable {
    
    @Published var movie: MediaItemDetail = MediaItemDetail()
    @Published var cast: [Contributors] = []
    @Published var mediaItems: [MediaItem] = []
    @Published var isLoading: Bool = false
    
    var isFavorite: Bool = false
    var actualPage: Int = 0
    var totalPages: Int = 500
    
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let movieIdSubject = PassthroughSubject<MediaItem, Never>()
    let similarMovieIdSubject = PassthroughSubject<Int, Never>()
    
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var favoriteMediaStorage: FavoriteMediaStoreProtocol
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    init() {
        
        let details = movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchDetailRequest(movieId: movieId.id)
                switch movieId.type {
                case .movie:
                    return self.repository.fetchMovieDetail(req: requset)
                case .tv:
                    return self.repository.fetchMovieDetail(req: requset)
                case .unknown:
                    return Just<MediaItemDetail>(MediaItemDetail())
                        .setFailureType(to: MovieError.self)
                        .eraseToAnyPublisher()
                }
            }
        
        let cast = movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<[Contributors], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let requset = FetchDetailRequest(movieId: movieId.id)
                switch movieId.type {
                case .movie:
                    return self.repository.fetchMovieCredits(req: requset)
                case .tv:
                    return self.repository.fetchMovieCredits(req: requset)
                case .unknown:
                    return Just<[Contributors]>(Array(repeating:Contributors(), count: 5))
                        .setFailureType(to: MovieError.self)
                        .eraseToAnyPublisher()
                }
                
            }
        
        Publishers.CombineLatest(details, cast)
            .receive(on: RunLoop.main)
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
                
            } receiveValue: { [weak self] movie, cast in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.cast = cast
                self.movie = movie
                self.isFavorite = self.favoriteMediaStorage.isFavoriteMediaItem(withId: movie.id)
                
            }
            .store(in: &cancellables)
        
        //        hasonló filmek lekérése
        similarMovieIdSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.actualPage += 1
            })
            .flatMap { [weak self] movieId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchSimilarMoviesRequest(movieId: movieId, page: actualPage)
                return self.repository.fetchSimilarMovies(req: requset)
            }
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .sink{ [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
                
            } receiveValue: { [weak self]  mediaItems in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                self.mediaItems.append(contentsOf: mediaItems)
                self.isLoading = false
            }
            .store(in: &cancellables)
        
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.movie.id, isFavorite:  isFavorite)
                return repository.editFavoriteMovie(req: request)
                    .map { result in
                        (result,isFavorite)
                    }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] result, isFavorite in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if result.success {
                    if isFavorite{
                        self.favoriteMediaStorage.addFavoriteMediaItem(MediaItem(detail: oself.movie))
                    } else {
                        self.favoriteMediaStorage.removeFavoriteMediaItem(withId: self.movie.id)
                    }
                    self.isFavorite = isFavorite
                }
                
            }
            .store(in: &cancellables)
    }
    
    
}
