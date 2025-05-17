//
//  CompanyResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//

struct CompanyListResponse: Decodable {
    let companies: [CompanyResponse]
}

struct CompanyResponse: Decodable {
    let id: Int
    let name: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
    case id
    case name
    case logoPath = "logo_path"
    }
}
