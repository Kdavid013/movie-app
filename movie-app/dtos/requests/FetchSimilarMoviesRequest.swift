//
//  FetchSimilarMoviesRequest.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 24..
//

struct FetchSimilarMoviesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let movieId: Int
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return ["page": page] + languageParam
                }
}
