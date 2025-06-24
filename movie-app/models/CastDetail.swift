//
//  CastDetail.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 09..
//
import Foundation

struct CastDetail: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let biography: String?
    let birthYear: String
    let popularity: Double
    let imageUrl: URL?
    let originPlace: String?
    
    init() {
        self.id = 0
        self.name = ""
        self.biography = nil
        self.birthYear = ""
        self.popularity = 0
        self.imageUrl = nil
        self.originPlace = nil
    }

    init(dto: CastDetailResponse) {
        var imageUrl: URL?{
            dto.profilePath.flatMap{
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.id = dto.id
        self.name = dto.name
        self.biography = dto.biography
        self.birthYear = dto.birthday
        self.originPlace = dto.birthplace
        self.popularity = dto.popularity
        self.imageUrl = imageUrl
    }
    
    init(dto: CompanyDetailResponse){
        var imageUrl: URL?{
            dto.logoPath.flatMap{
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.id = dto.id
        self.name = dto.name
        self.originPlace = dto.originCountry
        self.biography = dto.description
        self.popularity = 0.0
        self.birthYear = ""
        self.imageUrl = imageUrl
    }
}
