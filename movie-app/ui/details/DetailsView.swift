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
                    VStack(alignment: .leading, spacing:15){
                        MoviePicture(picUrl: viewModel.movie.imageUrl)
                        HStack(spacing:12){
                            MovieLabel(type: .rating(viewModel.movie.rating))
                            MovieLabel(type: .voteCount(vote: viewModel.movie.voteCount))
                            MovieLabel(type: .popularity(viewModel.movie.popularity))
                            Spacer()
                            MovieLabel(type: .captions(viewModel.movie.adult))
                        }
                        HStack{
                            VStack(alignment: .leading,spacing: 4){
                                Text(viewModel.movie.genreList)
                                    .font(Fonts.paragraph)
                                Text(viewModel.movie.title)
                                    .font(Fonts.detailTitle)
                            }
                            Spacer()
                        }
                        HStack(spacing: LayoutConst.normalPadding){
                            DetailLabel(title: "detail.label.date", desc: viewModel.movie.year)
                            DetailLabel(title: "detail.label.duration", desc: "\(viewModel.movie.runtime)")
                            DetailLabel(title: "detail.label.language", desc: viewModel.movie.spokenLanguages)
                            Spacer()
                        }
                        HStack(spacing: 24){
                            ButtonLabel(style: .outlined, text: "button.rate.title"){
                                
                            }
                            ButtonLabel(style: .filled, text: "button.imdb.title"){
                                
                            }
                        }
                        VStack(alignment: .leading, spacing: 12){
                            Text(LocalizedStringKey("overview"))
                                .font(Fonts.overviewText)
                            Text(viewModel.movie.overview)
                                .font(Fonts.paragraph)
                                .lineLimit(nil)
                        }
                        VStack(alignment: .leading){
                            Text("companies")
                                .font(Fonts.overviewText)
                            //                            ParticipantScrollView(participants: viewModel.movie.companies)
                            SideScrollView(contributors: viewModel.movie.companies)
                            Text("cast")
                                .font(Fonts.overviewText)
                            //                            ParticipantScrollView(participants: viewModel.cast)
                            SideScrollView(contributors: viewModel.cast)
                        }
                        
                        
                        .padding(.horizontal, LayoutConst.maxPadding)
                        Spacer()
                    }
                    
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action:{
                    viewModel.favoriteButtonTapped.send()
                }){
                    if viewModel.isFavorite{
                        Image(.favorite)
                            .resizable()
                            .frame(height: 30)
                            .frame(width: 30)
                    }else {
                        Image(.nonfavorite)
                            .resizable()
                            .frame(height: 30)
                            .frame(width: 30)
                        
                    }
                    
                    
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.movieIdSubject.send(mediaItem.id)
        }
        
    }
}

