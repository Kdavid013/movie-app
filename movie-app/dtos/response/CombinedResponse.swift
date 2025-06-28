//
//  CombinedResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 27..
//

struct CombinedResponse: Decodable {
    let combined: [MovieResponse]
    
    enum CodingKeys: String, CodingKey {
        case combined = "cast"
    }
}
