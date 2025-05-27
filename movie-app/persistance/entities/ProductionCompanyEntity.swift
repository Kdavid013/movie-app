//
//  ProductionCompanyEntity.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import RealmSwift
import Foundation

class ProductionCompanyEntity: Object {
    @Persisted var id: Int
    @Persisted var logoPath: String?
    @Persisted var name: String
//    @Persisted var originCountry: String

    convenience init(from model: Contributors) {
        self.init()
        self.id = model.id
        self.logoPath = model.imageUrl?.absoluteString
        self.name = model.name
//        self.originCountry = model.originCountry
    }

    var toDomain: Contributors {
        Contributors(id: id,
                     name: name,
                     imageUrl: logoPath.flatMap(URL.init(string:)) )
    }
}

