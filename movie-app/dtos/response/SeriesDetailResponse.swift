//
//  SeriesDetailResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 07. 01..
//

struct SeriesDetailResponse: Decodable {
    let id: Int
    let name: String
    let originalName: String
    let firstAirDate: String
    let lastAirDate: String
    let numberOfSeasons: Int
    let numberOfEpisodes: Int
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let genres: [GenreResponse]
    let popularity: Double
    let voteAverage: Double
    let voteCount: Int
    let inProduction: Bool
    let status: String
    let tagline: String
    let languages: [String]
    let spokenLanguages: [SpokenLanguageResponse]
    let productionCompanies: [CompanyResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case numberOfSeasons = "number_of_seasons"
        case numberOfEpisodes = "number_of_episodes"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case genres
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case inProduction = "in_production"
        case status
        case tagline
        case languages
        case spokenLanguages = "spoken_languages"
        case productionCompanies = "production_companies"
    }
}
