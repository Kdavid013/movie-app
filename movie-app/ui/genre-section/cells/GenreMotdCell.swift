//
//  GenreMotdCell.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 03..
//

import SwiftUI
import Shimmer

struct GenreMotdCell: View {
    
    let mediaItems: [MediaItemDetail]
    let onScreenIndex: Int
    
    var body: some View {
        if mediaItems.indices.contains(onScreenIndex) {
//            NavigationLink(destination: DetailsView(mediaItem: MediaItem(mediaItems[onScreenIndex]))){
                ZStack(alignment: .bottomLeading) {
                    LoadImageView(url: mediaItems[onScreenIndex].imageUrl)
                        .frame(width: 370, height: 185)
                        .cornerRadius(12)
                    VStack{
                        HStack{
                            ForEach(Array(mediaItems.enumerated()), id: \.element.id) { index, item in
                                Circle()
                                    .frame(width: 7.5 ,height: 7.5)
                                    .foregroundColor(index == onScreenIndex ? Color.blue : Color.gray)
                            }
                        }
                        
                        Spacer()
                        HStack {
                            VStack(alignment: .leading) {
                                Text(mediaItems[onScreenIndex].genreList)
                                    .font(Fonts.paragraphList)
                                Text(mediaItems[onScreenIndex].title)
                                    .font(Fonts.title)
                            }
                            .padding(LayoutConst.normalPadding)
                            
                            Spacer()
                            
                            Image(.playButton)
                                .frame(width: 48, height: 48)
                                .padding(LayoutConst.normalPadding)
                        }
                    }
                    
                }
                .padding(LayoutConst.maxPadding)
//            }

        } else {
            Rectangle()
                .frame(width: 370, height: 185)
                .shimmering()
        }
        
    }
}
