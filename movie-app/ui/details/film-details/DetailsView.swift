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
                            ButtonLabel(style: .outlined, title: "button.rate.title".localized(), action: .simple)
                        }
                        
                        ButtonLabel(style: .filled, title: "button.imdb.title".localized(), action: .link(viewModel.movie.imageUrl))
                    }
                    VStack(alignment: .leading, spacing: 12){
                        Text("overview".localized())
                            .font(Fonts.overviewText)
                        Text(viewModel.movie.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    VStack(alignment: .leading){
                        Text("companies".localized())
                            .font(Fonts.overviewText)
                        //                            ParticipantScrollView(participants: viewModel.movie.companies)
                        SideScrollView(contributors: viewModel.movie.companies, type: .company)
                        Text("cast".localized())
                            .font(Fonts.overviewText)
                        //                            ParticipantScrollView(participants: viewModel.cast)
                        SideScrollView(contributors: viewModel.cast, type: .cast)
                    }
                    Text("detail.similar.movies".localized())
                        .font(Fonts.title)
                    
                }
                .padding(.horizontal, LayoutConst.maxPadding)
                MovieSideScrollView(isLoading: viewModel.isLoading, mediaItems: viewModel.mediaItems,
                lastIdAppeared: { _ in
                    viewModel.similarMovieIdSubject.send(mediaItem.id)
                    return 0
                }, firstId: { (firstDescript: String, lastDescript: Int) -> Bool in
                    return true
                }
                )
                
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
            viewModel.movieIdSubject.send(mediaItem)
            viewModel.similarMovieIdSubject.send(mediaItem.id)
            viewModel.actualPage = 0
        }
    }
}

