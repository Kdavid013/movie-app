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
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .fetchGenres, .fetchTVGenres:
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
        }
    }
    
    var headers: [String : String]? {
//        metaadatok küldése, rejtett
        switch self{
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        }
    }    
}
