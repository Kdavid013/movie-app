//
//  MovieError.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 26..
//

import Foundation

enum MovieError: Error {
    case invalidApiKeyError(message: String)
    case unexpectedError
    case clientError
    case noInternetError
    case serverError
    case mapingError
    
    var domain: String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .noInternetError, .serverError, .mapingError:
                return "MovieError"
        }
    }
}

extension MovieError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
//            return "Invalid API key"
            return message
        case .unexpectedError:
            return "Unexpected error"
        case .clientError:
            return "Client error"
        case .noInternetError:
            return "No internet connection"
        case .serverError:
            return "Server error"
        case .mapingError:
            return "Couldn't map data"
        }
    }
}

