//
//  FavoritesView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//

import SwiftUI
import InjectPropertyWrapper

struct FavoritesView: View {
    
    @StateObject
    private var viewModel = FavoritesViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack(spacing: LayoutConst.normalPadding){
                    ForEach(viewModel.movies){ movie in
                        MovieCell(movie: movie)
                            .frame(height: 277)
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
            }
            .navigationTitle("favorites.title")
        }
        .showAlert(model: $viewModel.alertModel)
    }
}
