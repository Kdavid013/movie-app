//
//  MediaItemDetail.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 10..
//

import Foundation

struct MediaItemDetail: Identifiable {
    let id: Int
    let title: String
    let year: String
    let runtime: Int
    let imageUrl: URL?
//    let imdbUrl: URL?
    let rating: Double
    let voteCount: Int
    let overview: String
    let popularity: Double
    let genres: [String]
    let adult: Bool
    let spokenLanguages: String
    let companies: [Contributors]
    let type: MediaItemType
    
    init() {
        self.id = 0
        self.title = ""
        self.year = ""
        self.runtime = 0
        self.imageUrl = nil
//        self.imdbUrl = URL(string: "")
        self.rating = 0
        self.voteCount = 0
        self.overview = ""
        self.popularity = 0
        self.genres = []
        self.adult = false
        self.spokenLanguages = ""
        self.companies = []
        self.type = .movie
    }
    
    init(id: Int,
         title: String,
         year: String,
         runtime: Int,
         imageUrl: URL?,
//         imdbUrl: URL?,
         rating: Double,
         voteCount: Int,
         overview: String,
         popularity: Double,
         genres: [String],
         adult: Bool,
         spokenLanguages: String,
         companies: [Contributors],
         type: MediaItemType
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.runtime = runtime
        self.imageUrl = imageUrl
//        self.imdbUrl = imdbUrl
        self.rating = rating
        self.voteCount = voteCount
        self.overview = overview
        self.popularity = popularity
        self.genres = genres
        self.adult = adult
        self.spokenLanguages = spokenLanguages
        self.companies = companies
        self.type = type
    }
    
    init(dto: MovieDetailResponse) {
        let year = String(dto.releaseDate.prefix(4))
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.runtime = dto.runtime
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage
        self.voteCount = dto.voteCount
        self.overview = dto.overview
        self.popularity = dto.popularity
        self.genres = dto.genres.map(\.name)
        self.adult = dto.adult
        self.spokenLanguages = dto.spokenLanguages.map({$0.englishName}).joined(separator: ", ")
        self.companies = dto.companies.map(Contributors.init)
        self.type = .movie
//        self.imdbUrl = URL(string: "https://www.imdb.com/title/\(dto.imdbId)/")
    }
    var genreList: String {
        genres.joined(separator: ", ")
    }
}
