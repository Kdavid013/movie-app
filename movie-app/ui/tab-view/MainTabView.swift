//
//  MainTabView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI

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
