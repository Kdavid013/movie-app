//
//  MediaItemListByGenre.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 27..
//

import SwiftUI
import Shimmer

struct MediaItemListByGenre: View {
    
    let genre: Genre
    let mediaItems: [MediaItem]
    
    var body: some View {
        VStack{
            GenreSectionCell(genre: genre)
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    ForEach(mediaItems) {mediaItem in
                        NavigationLink(destination: DetailsView(mediaItem: mediaItem)) {
                            if (mediaItem.id == 0){
                                Rectangle()
                                    .frame(width: 200, height: 100)
                                    .shimmering()
                            } else {
                                MovieCell(movie: mediaItem)
                                    .frame(width: 200)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                    }
                }
            }
            .listRowBackground(Color.clear)
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
        }
        
    }
}
