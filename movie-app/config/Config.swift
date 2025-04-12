//
//  Config.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation

enum Config {
    private static let apiToken: String = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let token = dict["API_TOKEN"] as? String else {
            preconditionFailure("Config.plist file or API_TOKEN not found")
        }
        return token
    }()
    
    static var bearerToken: String {
        "Bearer \(apiToken)"
    }
}
