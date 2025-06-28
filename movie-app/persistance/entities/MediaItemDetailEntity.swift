//
//  MediaItemDetailEntitx.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//


import Foundation
import RealmSwift

class MediaItemDetailEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var runtime: Int
    @Persisted var imageUrl: String?
    @Persisted var rating: Double
    @Persisted var voteCount: Int
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var adult: Bool
    @Persisted var genres: List<String>
    @Persisted var spokenLanguages: String
//    @Persisted var imdbUrl: String?
    @Persisted var companies: List<ProductionCompanyEntity>

    convenience init(from model: MediaItemDetail) {
        self.init()
        self.id = model.id
        self.title = model.title
        self.year = model.year
        self.runtime = model.runtime
        self.imageUrl = model.imageUrl?.absoluteString
        self.rating = model.rating
        self.voteCount = model.voteCount
        self.overview = model.overview
        self.popularity = model.popularity
        self.adult = model.adult
        self.genres.append(objectsIn: model.genres)
        self.spokenLanguages = model.spokenLanguages
//        self.imdbUrl = model.imdbUrl?.absoluteString
        self.companies.append(objectsIn: model.companies.map(ProductionCompanyEntity.init))
    }

    var toDomain: MediaItemDetail {
        return MediaItemDetail(
            id: id,
            title: title,
            year: year,
            runtime: runtime,
            imageUrl: imageUrl.flatMap(URL.init),
            rating: rating,
            voteCount: voteCount,
            overview: overview,
            popularity: popularity,
            genres: Array(genres),
            adult: adult,
            spokenLanguages: spokenLanguages,
//            imdbUrl: imdbUrl.flatMap(URL.init(string:)),
            companies: companies.map { $0.toDomain },
            type: .movie
        )
    }
}
