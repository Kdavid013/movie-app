//
//  EditFavoriteResult.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 13..
//

struct EditFavoriteResult: Hashable, Equatable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    
    init(dto: EditFavoritesResult){
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
