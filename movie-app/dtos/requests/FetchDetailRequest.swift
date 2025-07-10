//
//  FetchMovieDetail.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//

struct FetchDetailRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:] + languageParam
    }
}

