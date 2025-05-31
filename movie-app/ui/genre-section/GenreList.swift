//
//  MediaItemListByGenre.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 27..
//

import SwiftUI


struct MediaItemListByGenre: View {
    
    let genre: Genre
    let mediaItems: [MediaItem]
    
    var body: some View {
        VStack{
            GenreSectionCell(genre: genre)
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    ForEach(mediaItems) {mediaItem in
                        MovieCell(movie: mediaItem)
                            .frame(width: 200)
                    }
                }
            }
            .listRowBackground(Color.clear)
        }
        
    }
}
