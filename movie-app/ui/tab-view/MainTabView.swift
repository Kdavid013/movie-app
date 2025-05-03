//
//  MainTabView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI

enum TabType: String,CaseIterable {
    case genre
    case searchtab
    case favorites
    case settings
}

struct TabIcon: Identifiable{
    var id: String = UUID().uuidString
    let tab : TabType
    let image: Image
}

struct MainTabView: View {
    
    @Binding var selectedTab: TabType
    @State var icons: [TabIcon] = {
        var tabs: [TabIcon] = []
        for tab in TabType.allCases {
            tabs.append(TabIcon(tab: tab, image: Image(tab.rawValue)))
        }
        return tabs
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                GenreSectionView()
                    .tag(TabType.genre)
                    .background(Color.tabBarBackground)
                    .ignoresSafeArea()
                SearchView()
                    .tag(TabType.searchtab)
                    .background(Color.tabBarBackground)
                    .ignoresSafeArea()
                FavoritesView()
                    .tag(TabType.favorites)
                    .background(Color.tabBarBackground)
                    .ignoresSafeArea()
                GenreSectionView()
                    .tag(TabType.settings)
                    .background(Color.tabBarBackground)
                    .ignoresSafeArea()
            }
            .background(.clear)
            .padding(.bottom,LayoutConst.largePadding)
            
            HStack{
                Spacer()
                ForEach(icons){ icon in
                    TabBarItemView(selectedTab: $selectedTab, icon:icon)
                    Spacer()
                }
            }
            .padding(.top, LayoutConst.largePadding)
            .padding(.bottom, 48.0 - safeArea().bottom)
            .background(
                Color.tabBarBackground
                    .clipShape(RoundedCorner(radius: 30.0, corners:[.topLeft, .topRight]))
                    .ignoresSafeArea(edges: .bottom)
            )
        }
    }
}
