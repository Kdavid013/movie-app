//
//  CastResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//

struct ListCastResponse: Decodable {
    let cast: [CastResponse]
}

struct CastResponse: Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
    case id
    case name
    case logoPath = "profile_path"
    }
}
