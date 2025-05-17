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
            LoadImageView(url: picUrl)
            .frame(maxHeight: 180)
            .frame(maxWidth: .infinity)
            .cornerRadius(30)
        }
        .padding(.bottom, LayoutConst.maxPadding)
    }
}
