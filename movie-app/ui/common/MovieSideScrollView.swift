//
//  MovieSideScrollView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 24..
//

import SwiftUI
import Lottie

struct MovieSideScrollView: View {
    
    let viewModel : DetailsViewModel
    
    let mediaItems : [MediaItem]
    
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack(spacing: 20) {
                ForEach(Array(mediaItems.enumerated()), id: \.element.id) {index, mediaItem in
                    NavigationLink(destination: DetailsView(mediaItemId: mediaItem.id)) {
                        MovieCell(movie: mediaItem)
                            .frame(width: 200)
                            .onAppear {
                                if viewModel.mediaItems.last?.id == mediaItem.id {
                                    viewModel.similarMovieIdSubject.send(mediaItem.id)
                                }
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
