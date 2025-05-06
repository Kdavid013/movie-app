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
    case searchMovies(req: SearchMovieRequest)
    case fetchFavorites(req: FetchFavoritesRequest)
    case fetchSeries(req: FetchSeriesRequest)
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
        case .fetchFavorites:
            return "account/"
        case .fetchSeries:
            return "discover/tv"
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .fetchGenres, .fetchTVGenres,.fetchMovies, .searchMovies, .fetchFavorites, .fetchSeries:
            return .get
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
        case let .fetchFavorites(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchSeries(req):
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
        case let .fetchFavorites(req):
            return ["Authorization": req.accessToken]
        case let .fetchSeries(req):
            return ["Authorization": req.accessToken]
        }
    }    
}
