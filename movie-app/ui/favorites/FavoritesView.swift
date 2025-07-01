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
        let items = viewModel.movies
        NavigationView {
            
                Group{
                if items.isEmpty {
                    VStack {
                        Spacer()
                        Text("No favorites yet")
                            .font(Fonts.heading)
                        Text("Add some favorites to see them here")
                            .font(Fonts.title)
                        Spacer()
                    }
                    .padding(.horizontal, LayoutConst.normalPadding)
                } else{
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
                }
            }
            .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
            .navigationTitle(LocalizedStringKey("favorites.title".localized()))
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.viewLoaded.send(())
        }
    }
}
