//
//  FetchMovieRequest.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

struct FetchMoviesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let genreId: Int?
    let page: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId ?? "",
                "page": page] + languageParam
                }
}

