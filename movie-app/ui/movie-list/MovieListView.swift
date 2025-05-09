//
//  MovieListView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper


struct MovieListView: View {
    
    let genre: Genre
    
    @StateObject private var viewModel = MovieListViewModel()
    //    csak genreval fog tud dolgozni
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    //    let columns = [let genre: Genre
    //        GridItem(.adaptive(minimum: 150), spacing: 16)
    //    ]
    
    var body: some View {
        ScrollView {
            //            pár cellát tart mindig a memóriába, csak annyit amennyi a képernyőn látszik
            //            columns - array amibe grid itemek kerülnek
            LazyVGrid(columns: columns, spacing: 24) {
                ForEach(viewModel.movies) { movie in
                    ZStack{
                        
                        NavigationLink(destination: DetailsView(movie: movie)){
                            MovieCell(movie: movie)
                        }
                        .foregroundColor(.invertedMain)
                    }
                    
                }
            }
            .padding(.horizontal, LayoutConst.normalPadding)
            .padding(.top, LayoutConst.normalPadding)
        }
        
        .navigationTitle(genre.name)
        .onAppear {
            viewModel.genreIdSubject.send(genre.id)
        }
    }
}

#Preview {
    GenreSectionView()
}
