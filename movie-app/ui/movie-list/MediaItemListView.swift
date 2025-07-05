//
//  MovieListView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper
import Lottie

struct MediaItemListView: View {
    
    let genre: Genre
    
    @EnvironmentObject
    var languageManager: LanguageManager
    
    @StateObject private var viewModel = MediaItemListViewModel()
    //    csak genreval fog tud dolgozni
    
    @State
    private var isAnimated: [Int] = []
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    //    let columns = [let genre: Genre
    //        GridItem(.adaptive(minimum: 150), spacing: 16)
    //    ]
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            RightCornerCircle()
            ScrollView {
                //            pár cellát tart mindig a memóriába, csak annyit amennyi a képernyőn látszik
                //            columns - array amibe grid itemek kerülnek
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(Array(viewModel.mediaItems.enumerated()), id: \.1.id ) {index, mediaItem in
                        NavigationLink(destination: DetailsView(mediaItem: mediaItem)){
                            MediaItemCell(movie: mediaItem)
                                .offset(y: isAnimated.contains(mediaItem.id) ? 0 : 200 )
                                .opacity(isAnimated.contains(mediaItem.id) ? 1 : 0)
                                .onAppear {
                                    if viewModel.mediaItems.last?.id == mediaItem.id {
                                        viewModel.reachedBottomSubject.send()
                                    }
                                    withAnimation(.easeInOut(duration: 0.5).delay(Double(index) * 0.001)){
                                        isAnimated.append(mediaItem.id)
                                    }
                                }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
                .padding(.top, LayoutConst.normalPadding)
                
                if viewModel.isLoading{
                    LottieView(animation: .named("loading"))
                        .playing(loopMode: .loop)
                }
            }
            .navigationTitle(genre.name)
            .onAppear {
                viewModel.genreIdSubject.send(genre.id)
            }
            .refreshable {
                isAnimated = []
                viewModel.mediaItems.removeAll()
                viewModel.actualPage = 0
                viewModel.genreIdSubject.send(genre.id)
            }
        }
        
    }
}

//#Preview {
//    GenreSectionView()
//}
