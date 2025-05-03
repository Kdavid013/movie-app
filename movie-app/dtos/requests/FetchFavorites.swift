//
//  FetchFavorites.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 03..
//

struct FetchFavoritesRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int
    
    func asRequestParams() -> [String: Any] {
        return ["account_id": accountId]
    }
}
