//
//  MainTabView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI

enum TabType: String,CaseIterable {
    case genre
    case search
    case favorite
    case settings
}

struct TabIcon: Identifiable{
    var id: String = UUID().uuidString
    let tab : TabType
    let image: Image
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                GenreSectionView()
            }
            
            .tabItem {
                Image(.home)
            }
            
            NavigationView{
                SearchView()
            }
            .tabItem {
                Image(.searchtab)
            }
        }
    }
}
