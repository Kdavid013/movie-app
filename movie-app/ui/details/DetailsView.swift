//
//  MovieListView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper


struct DetailsView: View {
    
    let movie: MediaItem
    
    //    @StateObject private var viewModel = DetailsViewModel()
    //    csak genreval fog tud dolgozni
    
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
            VStack{
                MoviePicture(picUrl: movie.imageUrl)
                HStack{
                        MovieLabel(type: .rating(movie.rating))
                        MovieLabel(type: .voteCount(vote: movie.voteCount))
                        MovieLabel(type: .views(240240))
                        Spacer()
                        MovieLabel(type: .captions("Available"))
                }
                .padding(.bottom, LayoutConst.normalPadding)
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Genres placeholder")
                            .font(Fonts.paragraph)
                        Text(movie.title)
                            .font(Fonts.detailTitle)
                    }
                    Spacer()
                }
                .padding(.bottom, LayoutConst.smallPadding)
                HStack(spacing: LayoutConst.smallPadding){
                    DetailLabel(type: .date(movie.year))
                    DetailLabel(type: .duration(movie.duration))
                    DetailLabel(type: .language("English"))
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

#Preview {
    GenreSectionView()
}
