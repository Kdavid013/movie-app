//
//  SideScrollView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 11..
//

import SwiftUI
import Foundation

enum contributorType{
    case cast
    case company
}

struct SideScrollView: View {
    
    let contributors: [Contributors]
    let type: contributorType
    
    var body: some View {
        
//        enum contributorType{
//            case cast(cast: Contributors)
//            case company(company: Contributors)
//        }
        
        return ScrollView(.horizontal){
           
            HStack(spacing:20){
                ForEach(contributors) { contributor in
                    switch type {
                    case .company:
                        NavigationLink(destination: CastDetailsView(castDetailType: .company(id: contributor.id))){
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
                    case .cast:
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
}


