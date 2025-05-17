//
//  DetailLabel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//


import SwiftUI


struct DetailLabel: View {
    
    var title: String
    var desc: String
    

    var body: some View {
                
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            Text(LocalizedStringKey(title))
                .font(Fonts.caption)
            Text(desc)
                .font(Fonts.paragraph)
        }
//        .padding(LayoutConst.normalPadding)
    }
}
