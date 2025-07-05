//
//  ModifyMediaResult.swift
//  movie-app
//
//  Created by David Karacs on 2025. 07. 05..
//

struct ModifyMediaResult {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    init(dto: ModifyMediaResultResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
