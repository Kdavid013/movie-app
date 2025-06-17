//
//  CastDetailResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 09..
//

struct CastDetailResponse: Decodable {
    let id: Int
    let name: String
    let biography: String
    let birthday: String
    let birthplace: String
    let popularity: Double
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case biography
        case birthday
        case birthplace = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}
