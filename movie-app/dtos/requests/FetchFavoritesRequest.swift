//
//  FetchFavorites.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 03..
//

struct FetchFavoritesRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
