//
//  movie_appApp.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 08..
//

import SwiftUI

@main
struct movie_appApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var selectedTab: TabType = TabType.genre
    
    @AppStorage("color-scheme") var colorSchemeRawValue: String = "light"
    
    var colorScheme: ColorScheme {
        if colorSchemeRawValue == "dark" {
            return .dark
        } else {
            return .light
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(selectedTab: selectedTab)
                .preferredColorScheme(colorScheme)
        }
    }
}
