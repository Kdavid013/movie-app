//
//  ReactiveMovieService.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine
import Alamofire

protocol ReactiveMoviesServiceProtocol {
    //    viszsatérés any publisher, lecsupaszított adat típus
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchSeries(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchFavorites(req: FetchFavoritesRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoritesResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchMovieCredits(req: FetchDetailRequest) -> AnyPublisher<[Contributors], MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    private var detailStore: MediaItemDetailStoreProtocol
    
    @Inject
    private var networkMonitor: NetworkMonitorProtocol
    
    @Inject
    private var castMemberStore: CastMemberStoreProtocol
    
    func fetchSeries(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchSeries(req: req)),
            decodeTo: SeriesPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovieCredits(req: FetchDetailRequest) -> AnyPublisher<[Contributors], MovieError> {
            
            return networkMonitor.isConnected
                .flatMap { isConnected -> AnyPublisher<[Contributors], MovieError> in
                    if isConnected {
                        return self.requestAndTransform(
                            target: MultiTarget(MoviesApi.fetchMovieCredits(req: req)),
                            decodeTo: ListCastResponse.self,
                            transform: { dto in
                                dto.cast.map(Contributors.init(dto:))
                            }
                        )
                        .handleEvents(receiveOutput: { [weak self]castMembers in
                            self?.castMemberStore.saveCastMembers(castMembers, forMovieId: req.movieId)
                        })
                        .eraseToAnyPublisher()
                    } else {
                        return self.castMemberStore.getCastMembers(fromMovieId: req.movieId)
                    }
                }
                .eraseToAnyPublisher()
        }
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        
        let serviceResponse : AnyPublisher<MediaItemDetail, MovieError> = requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail(dto: $0)}
        )
            .handleEvents(receiveOutput:{ [weak self] MediaItemDetail in
                self?.detailStore.saveMediaItemDetail(MediaItemDetail)
        })
        .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<MediaItemDetail, MovieError> = detailStore.getMediaItemDetail(withId: req.movieId)
        
        return networkMonitor.isConnected
            .flatMap{ isconnected -> AnyPublisher<MediaItemDetail, MovieError> in
                if isconnected {
                    return serviceResponse
                } else{
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoritesResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: EditFavoritesResult.self,
            transform: { response in response }
        )
    }
    
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchFavorites(req: FetchFavoritesRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
        
        let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavorites(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput:{ [weak self] mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
        
        let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
        
        return networkMonitor.isConnected
            .flatMap{ isconnected -> AnyPublisher<[MediaItem], MovieError> in
                if isconnected || !fromLocal{
                    return serviceResponse
                } else{
                    return localResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(.unexpectedError))
                        }
                    case 400..<500:
                        future(.failure(.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(.unexpectedError))
                            }
                        } else {
                            future(.failure(.unexpectedError))
                        }
                    }
                case .failure(let error):
                    if error.isNoInternetError {
                        future(.failure(MovieError.noInternetError))
                    } else {
                        future(.failure(MovieError.unexpectedError))
                    }
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
