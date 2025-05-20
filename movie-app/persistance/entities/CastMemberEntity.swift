//
//  CastMemberEntity.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import RealmSwift
import Foundation

class CastMemberEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var imageUrlString: String?
    @Persisted var movieId: Int
}
extension CastMemberEntity {
    var toDomain: Contributors {
        Contributors(
            id: id,
            name: name,
            imageUrl: imageUrlString.flatMap(URL.init(string:))
        )
    }
    
    convenience init(from domains: Contributors, movieId: Int){
        self.init()
        self.id = domains.id
        self.name = domains.name
        self.imageUrlString = domains.imageUrl?.absoluteString
        self.movieId = movieId
    }
}
