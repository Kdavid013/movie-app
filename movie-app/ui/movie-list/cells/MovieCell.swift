//
//  MovieCell.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 26..
//

import SwiftUI

struct MovieCell: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    AsyncImage(url: movie.imageUrl) { phase in
                        switch phase {
                            //                            még nem töltődött be
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.3)
                                ProgressView()
                            }
                            //                      sikeres letöltés
                        case .success(let image):
                            image
                            //                            ha nincs akkor a tényleges méretet probálja betölteni
                                .resizable()
                            //                            szélesség széthuzva
                                .scaledToFill()
                            //                      ha nem sikerül letölteni egy képet
                        case .failure:
                            ZStack {
                                Color.red.opacity(0.3)
                                Image(systemName: "photo")
                                    .foregroundColor(.white)
                            }
                            // minden más esetétben ez fut le
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 100)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                //TODO: Import star image and add new font
                HStack(spacing: 12.0){
                    MovieLabel( type: .rating(movie.rating))
                    MovieLabel( type: .voteCount(vote: movie.voteCount))
                }
                .padding(LayoutConst.smallPadding)
                
            }
            HStack{
                VStack(alignment: .leading){
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .lineLimit(2)

                    Text("\(movie.year)")
                        .font(Fonts.paragraph)

                    Text("\(movie.duration)")
                        .font(Fonts.caption)
                }

                Spacer()
                
                ZStack{
                    RoundedCorner(radius: 20)
                        .foregroundStyle(.tabBarBackground)
                    Image(.playic)
                        .renderingMode(.template)
                        .foregroundStyle(.invertedMain)
                        .frame(width: 24, height: 24)
                }.frame(width: 40.0, height: 40.0)
            }
        }
    }
}
