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
        
        enum contributorType{
            case cast(cast: Contributors)
            case company(company: Contributors)
        }
        
        return ScrollView(.horizontal){
            HStack(spacing:20){
                ForEach(contributors) { contributor in
                    NavigationLink(destination: CastDetailsView(castDetailType: .castMember(id: contributor.id))){
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
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}


