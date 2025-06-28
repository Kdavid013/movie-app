//
//  MoviesApi.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
    case searchMovies(req: SearchMediaItemRequest)
    case searchTvs(req: SearchMediaItemRequest)
    case fetchFavorites(req: FetchFavoritesRequest)
    case fetchSeries(req: FetchMoviesRequest)
    case editFavoriteMovie(req: EditFavoriteRequest)
    case fetchMovieDetail(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchDetailRequest)
    case addReview(req: AddReviewRequest)
    case fetchCastDetail(req: FetchDetailRequest)
    case fetchCompanyDetail(req: FetchDetailRequest)
    case fetchSimilarMovies(req: FetchSimilarMoviesRequest)
    case fetchCombinedCredits(req: FetchDetailRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        let baseUrl = "https://api.themoviedb.org/3"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid")
        }
        return baseUrl
    }
    
    var path: String {
        switch self{
        case .fetchGenres:
            return "/genre/movie/list"
        case .fetchTVGenres:
            return "/genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .searchTvs:
            return "search/tv"
        case let .fetchFavorites(req):
            return "account/\(req.accountId)/favorite/movies"
        case .fetchSeries:
            return "discover/tv"
        case let .editFavoriteMovie(req: req):
            return "account/\(req.accountId)/favorite"
        case let .fetchMovieDetail(req: req):
            return "/movie/\(req.movieId)"
        case let .fetchMovieCredits(req:  req):
            return "/movie/\(req.movieId)/credits"
        case let .addReview(req: req):
            return "account/\(req.mediaId)/rating"
        case let .fetchCastDetail(req: req):
            return "/person/\(req.movieId)"
        case let .fetchCompanyDetail(req: req):
            return "/company/\(req.movieId)"
        case let .fetchSimilarMovies(req: req):
            return "/movie/\(req.movieId)/similar"
        case let .fetchCombinedCredits(req: req):
            return "/person/\(req.movieId)/combined_credits"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .fetchGenres, .fetchTVGenres,.fetchMovies, .searchMovies, .searchTvs, .fetchFavorites, .fetchSeries, .fetchMovieDetail, .fetchMovieCredits, .fetchCastDetail, .fetchCompanyDetail, .fetchSimilarMovies, .fetchCombinedCredits:
            return .get
        case .editFavoriteMovie,.addReview:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self{
        case let .fetchGenres(req):
//            ez adja meg a get method paramétereit
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTVGenres(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchTvs(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavorites(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchSeries(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .editFavoriteMovie(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.httpBody)
//            let request = EditFavoriteRequest(movieId: req.movieId, isFavorite: req.isFavorite)
//            return .requestJSONEncodable(request)
        case let .fetchMovieDetail(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovieCredits(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .addReview(req):
//            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
            let request = AddReviewRequest(mediaId: req.mediaId, rating: req.rating)
                       return .requestJSONEncodable(request)
        case let .fetchCastDetail(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCompanyDetail(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchSimilarMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchCombinedCredits(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
//        metaadatok küldése, rejtett
        switch self{
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return ["Authorization": req.accessToken]
        case let .searchTvs(req):
            return ["Authorization": req.accessToken]
        case let .fetchFavorites(req):
            return ["Authorization": req.accessToken]
        case let .fetchSeries(req):
            return ["Authorization": req.accessToken]
        case let .editFavoriteMovie(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovieDetail(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovieCredits(req):
            return ["Authorization": req.accessToken]
        case let .addReview(req):
            return ["Authorization": req.accessToken]
        case let .fetchCastDetail(req):
            return ["Authorization": req.accessToken]
        case let .fetchCompanyDetail(req):
            return ["Authorization": req.accessToken]
        case let .fetchSimilarMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchCombinedCredits(req):
            return ["Authorization": req.accessToken]
        }
    }
}
