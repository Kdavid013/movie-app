//
//  MovieSideScrollView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 24..
//

import SwiftUI
import Lottie

struct MovieSideScrollView: View {
    
    var isLoading: Bool
    let mediaItems : [MediaItem]
    let lastIdAppeared: (Int) -> Int
    let firstId: (String, Int) -> Bool
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 20) {
                ForEach(Array(mediaItems.enumerated()), id: \.element.id) {index, mediaItem in
                    NavigationLink(destination: DetailsView(mediaItem: mediaItem)) {
                        MediaItemCell(movie: mediaItem)
                            .frame(width: 200)
                            .onAppear {
                                if mediaItems.last?.id == mediaItem.id {
                                    lastIdAppeared(mediaItem.id)
                                    _ = firstId(mediaItems.first?.id.description ?? "", mediaItem.id)
                                }
                            }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                if isLoading{
                    LottieView(animation: .named("loading"))
                        .playing(loopMode: .loop)
                        .frame(width: 50, height: 50)
                }
            }
           
        }
        .listRowBackground(Color.clear)
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
    }
}
