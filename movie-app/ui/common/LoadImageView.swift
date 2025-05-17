//
//  LoadImageView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 17..
//

import SwiftUI
import SDWebImageSwiftUI

struct LoadImageView: View {
    var url: URL?
    
    var body: some View {
        WebImage(url: url){ image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ZStack{
                Color.gray.opacity(0.3)
                ProgressView()
            }
        }
    }
}
