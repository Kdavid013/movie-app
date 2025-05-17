//
//  SideScrollView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//

import SwiftUI
import Foundation

struct SideScrollView: View {
    
    let contributors: [Contributors]
    
    var body: some View {
        
        return ScrollView(.horizontal){
            HStack(spacing:20){
                ForEach(contributors) { contributor in
                    VStack{
                        LoadImageView(url: contributor.imageUrl)
                        .frame(width: 56, height: 56)
                        .cornerRadius(28)
                        Text(contributor.name)
                            .font(Fonts.paragraph)
                            .lineLimit(nil)
                    }
                    .frame(width: 100.0)
                }
            }
        }
    }
}


