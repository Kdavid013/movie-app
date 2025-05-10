//
//  MoviePicture.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//
import SwiftUI

struct MoviePicture: View{
    
    let picUrl : URL?
    
    var body: some View {
        
        return HStack(alignment: .center) {
            AsyncImage(url: picUrl) { phase in
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
            .frame(maxHeight: 180)
            .frame(maxWidth: .infinity)
            .cornerRadius(30)
        }
        .padding(.bottom, LayoutConst.maxPadding)
    }
}
