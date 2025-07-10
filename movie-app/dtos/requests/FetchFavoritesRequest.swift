//
//  FetchFavorites.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 03..
//

struct FetchFavoritesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let accountId: String = Config.accountId
    
    func asRequestParams() -> [String: Any] {
        return [:] + languageParam
    }
}
