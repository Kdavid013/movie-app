//
//  MovieLabel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 26..
//

import SwiftUI

enum MovieLabelType{
    case rating(_ value: Double)
    case voteCount(vote: Int)
}

struct MovieLabel: View {
        
    let type: MovieLabelType
    
    var body: some View {
        var imageRes: ImageResource
        var text: String
        switch type {
        case .rating(let value):
            text = String(format: "%.1f", value)
            imageRes = .star
        case .voteCount(let vote):
            text = "\(vote)"
            imageRes = .heart
        }
        
        return HStack(spacing: 4.0) {
            Image(imageRes)
            Text(text)
                .font(Fonts.labelBold)
        }
        .padding(4)
        .background(Color.main.opacity(0.5))
        .cornerRadius(12)
    }
}
