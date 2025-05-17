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
                    LoadImageView(url: participant.imageUrl)
                    .frame(width: 56, height: 56)
                    .cornerRadius(28)
                    Text(participant.name)
                        .font(Fonts.paragraph)
                }
            }
        }
    }
}
