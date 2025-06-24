//
//  CompanyDetail.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 14..
//
import Foundation

struct CompanyDetail: Identifiable, Hashable, Equatable {
    let id: Int
    let name: String
    let description: String?
    let headquarters: String?
    let homepage: String?
    let originCountry: String?
    let imageUrl: URL?

    init(dto: CompanyDetailResponse) {
        var imageUrl: URL?{
            dto.logoPath.flatMap{
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.name = dto.name
        self.description = dto.description
        self.headquarters = dto.headquarters
        self.homepage = dto.homepage
        self.originCountry = dto.originCountry
        self.imageUrl = imageUrl
    }
}
