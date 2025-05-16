//
//  SideScrollView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//

import SwiftUI
import Foundation

enum SideScrollViewType{
    case companies(_ companies: [Contributors])
    case actors(_ actors: [Contributors])
}

struct SideScrollView: View {
    
    let type: SideScrollViewType
    
    let rows = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    var body: some View {
        var images: [URL?]
        var names: [String]
        var listofData: [(URL?,String)]
        switch type {
        case .companies(let value):
            images = value.map({$0.imageUrl})
            names = value.map({$0.name})
            listofData = zip(images,names).map({$0})
        case .actors(let value):
            images = value.map({$0.imageUrl})
            names = value.map({$0.name})
            listofData = zip(images,names).map({$0})
        }
        
        return ScrollView(.horizontal){
            HStack(spacing:20){
                ForEach(listofData, id: \.1) { data in
                    VStack{
                        AsyncImage(url: data.0) { phase in
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
                        .frame(width: 56, height: 56)
                        .cornerRadius(28)
                        Text(data.1)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    .frame(width: 100.0)
                }
            }
        }
    }
}
