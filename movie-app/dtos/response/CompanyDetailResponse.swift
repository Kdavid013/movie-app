//
//  CompanyDetailResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 14..
//

struct CompanyDetailResponse: Decodable {
    let id: Int
    let name: String
    let description: String?
    let headquarters: String?
    let homepage: String?
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case headquarters
        case homepage
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
