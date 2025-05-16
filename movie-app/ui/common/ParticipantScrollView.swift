//
//  ParticipantScrolView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 13..
//

import SwiftUI

protocol ParticipantItemProtocol {
    var imageUrl: URL? {get}
    var name: String {get}
    
}

struct ParticipantScrollView: View {
    
    let participants: [Contributors]
    
    var body: some View {
        HStack(spacing:20){
            ForEach(participants) { participant in
                VStack{
                    AsyncImage(url: participant.imageUrl) { phase in
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
                    Text(participant.name)
                        .font(Fonts.paragraph)
                }
            }
        }
    }
}
