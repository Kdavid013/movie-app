//
//  DetailResponse.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//

struct MovieDetailResponse: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let genres: [GenreResponse]
    let popularity: Double
    let adult: Bool
    let runtime: Int
    let spokenLanguages: [SpokenLanguageResponse]
    let overview: String
    let companies: [CompanyResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genres
        case popularity
        case adult
        case runtime
        case spokenLanguages = "spoken_languages"
        case overview
        case companies = "production_companies"
    }
}
