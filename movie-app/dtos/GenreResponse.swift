//
//  GenreResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation
import Moya

struct GenreListResponse: Decodable{
    let genres: [GenreResponse]
}

struct GenreResponse: Decodable {
    let id: Int
    let name: String
}
