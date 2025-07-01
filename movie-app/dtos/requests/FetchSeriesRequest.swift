//
//  FetchSeries.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 03..
//

struct FetchSeriesRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId] + languageParam
    }
}
