//
//  SpokenLanguageResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 10..
//

struct SpokenLanguageResponse: Decodable {
    let englishName: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
    }
}

