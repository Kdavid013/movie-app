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
    
    @EnvironmentObject var languageManager: LanguageManager
    
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
                    MoviePicture(picUrl: viewModel.mediaItem.imageUrl)
                    HStack(spacing:12){
                        MovieLabel(type: .rating(viewModel.mediaItem.rating))
                        MovieLabel(type: .voteCount(vote: viewModel.mediaItem.voteCount))
                        MovieLabel(type: .popularity(viewModel.mediaItem.popularity))
                        Spacer()
                        MovieLabel(type: .captions(viewModel.mediaItem.adult))
                    }
                    HStack{
                        Text(viewModel.mediaItem.genreList)
                            .font(Fonts.paragraph)
                        Spacer()
                    }
                    MediaItemHeaderView(title: viewModel.mediaItem.title, year: viewModel.mediaItem.year, runtime: "\(viewModel.mediaItem.runtime)", language: viewModel.mediaItem.spokenLanguages)
                    HStack(spacing: 24){
                        NavigationLink(destination: AddReviewView(mediaItemDetail: viewModel.mediaItem)){
                            ButtonLabel(style: .outlined, title: "button.rate.title".localized(), action: .simple)
                        }
                        if viewModel.mediaItem.imdbUrl != nil{
                            ButtonLabel(style: .filled, title: "button.imdb.title".localized(), action: .link(viewModel.mediaItem.imdbUrl))
                        }
                    }
                    VStack(alignment: .leading, spacing: 12){
                        Text("overview".localized())
                            .font(Fonts.overviewText)
                        Text(viewModel.mediaItem.overview)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    VStack(alignment: .leading){
                        Text("companies".localized())
                            .font(Fonts.overviewText)
                        //                            ParticipantScrollView(participants: viewModel.movie.companies)
                        SideScrollView(contributors: viewModel.mediaItem.companies, type: .company)
                        Text("cast".localized())
                            .font(Fonts.overviewText)
                        //                            ParticipantScrollView(participants: viewModel.cast)
                        SideScrollView(contributors: viewModel.cast, type: .cast)
                    }
                    ReviewScrollView(reviews: viewModel.reviews)
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
            viewModel.mediaItemSubject.send(mediaItem)
            viewModel.similarMovieIdSubject.send(mediaItem.id)
            viewModel.actualPage = 0
        }
    }
}

