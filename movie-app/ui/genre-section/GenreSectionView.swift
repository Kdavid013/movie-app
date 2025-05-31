//
//  ContentView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper


struct GenreSectionView: View {
    
    @StateObject
    private var viewModel = GenreSectionViewModelImpl()
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .topTrailing){
                HStack{
                    Spacer()
                    VStack{
                        Image(.circle)
                            .ignoresSafeArea(edges: .top)
                        Spacer()
                    }
                }
                List(viewModel.genres){ genre in
                    ZStack{
                        NavigationLink(destination: MovieListView(genre: genre)){
                            EmptyView()
                        }
                        .opacity(0)
                        
                        let mediaItems = viewModel.getMediaItemsByGenre(genre.id)
                        
                        MediaItemListByGenre(genre: genre, mediaItems: mediaItems)
                            .onAppear {
                                if viewModel.mediaItemsByGenre[genre.id] == nil {
                                    viewModel.loadMediaItems(genreId: genre.id)
                                }
                            }
                    }
                    .background(Color.clear)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                }
                .accessibilityLabel("testCollectionView")
                .listStyle(.plain)
                .navigationTitle(Environments.name == .tv ? "TV app":"genreSection.title")
                .background(Color.clear)
                .padding(.bottom,LayoutConst.largePadding)
            }
            .listStyle(.plain)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear{
            viewModel.loadGenres()
            viewModel.genreAppeared()
        }
    }
}


#Preview {
    GenreSectionView()
}
