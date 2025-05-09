//
//  DetailLabel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//


import SwiftUI

enum DetailLabelType{
    case date(_ date: String)
    case duration(_ duration: String)
    case language(_ language: String)
}

struct DetailLabel: View {
        
    let type: DetailLabelType
    
    var body: some View {
        var text: String
        var textTitle: Text
        switch type {
        case .date(let value):
            textTitle = Text("detail.label.date")
            text = value
        case .duration(let duration):
            textTitle = Text("detail.label.duration")
            text = duration
        case .language(let language):
            textTitle = Text("detail.label.language")
            text = language
        }
        
        return VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            textTitle
                .font(Fonts.caption)
            Text(text)
                .font(Fonts.paragraph)
        }
//        .padding(LayoutConst.normalPadding)
    }
}
