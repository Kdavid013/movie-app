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
    
    @AppStorage("color-scheme") var colorScheme: Theme = .light
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .preferredColorScheme(ColorScheme(theme: colorScheme))
        }
    }
}
