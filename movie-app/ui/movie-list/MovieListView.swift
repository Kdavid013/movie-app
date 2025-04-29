//
//  MovieListView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper


struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
//    csak genreval fog tud dolgozni
    let genre: Genre
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
//    let columns = [
//        GridItem(.adaptive(minimum: 150), spacing: 16)
//    ]
    
    var body: some View {
        ScrollView {
//            pár cellát tart mindig a memóriába, csak annyit amennyi a képernyőn látszik
//            columns - array amibe grid itemek kerülnek
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.movies) { movie in
                    MovieCell(movie: movie)
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        .navigationTitle(genre.name)
        .onAppear {
            Task {
                await viewModel.loadMovies(by: genre.id)
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
