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
                List{
                    HStack{
                        if let motd = viewModel.motdMovies {
                            GenreMotdCell(mediaItems: motd, onScreenIndex: viewModel.onScreenIndex)
                                .animation(.spring(response: 1))
                                .onAppear {
                                    viewModel.indexChanger(state: true)
                                }
                                .onDisappear {
                                    viewModel.stopIndexChanger()
                                }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    
                    ForEach(viewModel.genres){ genre in
                        ZStack{
                            NavigationLink(destination: MediaItemListView(genre: genre)){
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
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .accessibilityLabel(AccessibilityLabels.genreSectionCollectionView)
                .navigationTitle(Environments.name == .tv ? "TV app":"genreSection.title".localized())
                .padding(.bottom,LayoutConst.largePadding)
            }
            .listStyle(.plain)
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear{
            viewModel.mediaItemsByGenre.removeAll()
            viewModel.loadGenres()
            viewModel.genreAppeared()
        }
    }
}


#Preview {
    GenreSectionView()
}
