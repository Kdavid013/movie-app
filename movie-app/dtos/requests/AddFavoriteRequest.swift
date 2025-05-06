//
//  AddFavoriteRequest.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 06..
//

struct AddFavoriteRequest: Codable {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
