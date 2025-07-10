//
//  MediaItemHeaderView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import SwiftUI
import InjectPropertyWrapper

struct MediaItemHeaderView: View {
    
    let title: String
    let year: String
    let runtime: String
    let language: String
    
    var body: some View {
        VStack(alignment:.leading){
            Text(title)
                .font(Fonts.detailTitle)
            HStack(spacing: LayoutConst.normalPadding){
                
                DetailLabel(title: "detail.label.date", desc: year)
                DetailLabel(title: "detail.label.duration", desc: runtime)
                DetailLabel(title: "detail.label.language", desc: language)
                Spacer()
            }
        }
        
    }
    
}
