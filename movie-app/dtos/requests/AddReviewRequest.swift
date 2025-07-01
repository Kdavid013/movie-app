//
//  AddReviewRequest.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 24..
//

struct AddReviewBodyRequest: Encodable {
    let mediaId: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case mediaId = "media_id"
        case rating
    }
}

struct AddReviewRequest: Encodable, LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let rating: Double
    
    func asRequestParameters() -> [String: Any] {
        return [
            "media-id" : mediaId,
            "rating": rating
        ] + languageParam
    }
}
