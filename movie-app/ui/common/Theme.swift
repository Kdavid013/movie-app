//
//  Theme.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 31..
//

import SwiftUI

enum Theme: String{
    case light
    case dark
}

extension ColorScheme{
    init(theme: Theme){
        switch theme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        }
    }
    
    var asTheme: Theme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        @unknown default :
            return .light
        }
    }
}

