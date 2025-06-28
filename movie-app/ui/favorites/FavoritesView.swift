//
//  FavoritesView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    
    @StateObject private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: LayoutConst.normalPadding) {
                    ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
                        NavigationLink(destination: DetailsView(mediaItem: movie)){
                            MediaItemCell(movie: movie)
                                .accessibilityLabel("MediaItem \(index)")
                                .frame(height: 277)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
            .navigationTitle(LocalizedStringKey("favorites.title"))
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}
