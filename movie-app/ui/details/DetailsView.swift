//
//  MovieListView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper


struct DetailsView: View {
    
    let mediaItem: MediaItem
    
    @StateObject private var viewModel = DetailsViewModel()

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
                ScrollView{
                    VStack{
                        MoviePicture(picUrl: viewModel.movie.imageUrl)
                        HStack(spacing:12){
                                MovieLabel(type: .rating(viewModel.movie.rating))
                                MovieLabel(type: .voteCount(vote: viewModel.movie.voteCount))
                                MovieLabel(type: .popularity(viewModel.movie.popularity))
                                Spacer()
                            MovieLabel(type: .captions(viewModel.movie.adult))
                        }
                        .padding(.bottom, LayoutConst.normalPadding)
                        
                        HStack{
                            VStack(alignment: .leading){
                                Text(viewModel.movie.genreList)
                                        .font(Fonts.paragraph)
                                Text(viewModel.movie.title)
                                    .font(Fonts.detailTitle)
                            }
                            Spacer()
                        }
                        .padding(.bottom, LayoutConst.smallPadding)
                        HStack(spacing: LayoutConst.smallPadding){
                            DetailLabel(title: "detail.label.date", desc: viewModel.movie.year)
                            DetailLabel(title: "detail.label.duration", desc: "\(viewModel.movie.runtime)")
                            DetailLabel(title: "detail.label.language", desc: viewModel.movie.spokenLanguages)
                            Spacer()
                        }
                        .padding(.bottom, LayoutConst.normalPadding)
                        HStack(spacing: 24){
                            ButtonLabel(text: Text("button.rate.title"))
                            ButtonLabel(text: Text("button.imdb.title"))
                        }
                        
                    }
                    .padding(LayoutConst.maxPadding)
                    Spacer()
                }
                
            }
        }
        .onAppear {
            viewModel.movieIdSubject.send(mediaItem.id)
        }
        
    }
}
