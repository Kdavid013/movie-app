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
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
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
                                Text(viewModel.movie.genreList)
                                    .font(Fonts.paragraph)
                            Spacer()
                        }
                        MediaItemHeaderView(title: viewModel.movie.title, year: viewModel.movie.year, runtime: "\(viewModel.movie.runtime)", language: viewModel.movie.spokenLanguages)
                        HStack(spacing: 24){
                            NavigationLink(destination: AddReviewView(mediaItemDetail: viewModel.movie)){
                                ButtonLabel(style: .outlined, title: "button.rate.title", action: .simple)
                            }
                            
                            ButtonLabel(style: .filled, title: "button.imdb.title", action: .simple)
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
                        Spacer()
                    }
                    .padding(.horizontal, LayoutConst.maxPadding)
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

