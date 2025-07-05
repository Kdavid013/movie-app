//
//  SplashScreen.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 31..
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    
    @State var selectedTab: TabType = TabType.genre
    @State var animationFinished: Bool = false
    
    var body: some View {
        if animationFinished {
            RootView(selectedTab: selectedTab)
                .environmentObject(LanguageManager.shared)
        } else {
            LottieView(animation: .named("movies"))
                .playing(loopMode: .playOnce)
                .animationDidFinish { finished in
                    animationFinished.toggle()
                }
        }
    }
}
