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
    var isFavorite: Bool = false
    
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let movieIdSubject = PassthroughSubject<Int, Never>()
    
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
                
                let requset = FetchDetailRequest(movieId: movieId)
                return self.repository.fetchMovieDetail(req: requset)
            }
        
        let cast = movieIdSubject
            .flatMap { [weak self] movieId -> AnyPublisher<[Contributors], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let requset = FetchDetailRequest(movieId: movieId)
                return self.repository.fetchMovieCredits(req: requset)
            }
        
        //
        details.combineLatest(cast)
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
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = self.isFavorite
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
                        //                        self.favoriteMediaStorage.addFavoriteMediaItem(withId: self.movie)
                    } else {
                        self.favoriteMediaStorage.removeFavoriteMediaItem(withId: self.movie.id)
                    }
                    self.isFavorite = isFavorite
                }
                
            }
            .store(in: &cancellables)
    }
    
    
}
