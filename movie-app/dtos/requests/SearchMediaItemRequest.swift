//
//  SearchMovieRequest.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

struct SearchMediaItemRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let query : String
    
    func asRequestParams() -> [String: Any] {
        return ["query": query] + languageParam
    }
}
