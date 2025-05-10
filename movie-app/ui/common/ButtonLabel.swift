//
//  ButtonLabel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//
import SwiftUI

enum ButtonLabelType{
    case filled
    case outlined
}

struct ButtonLabel: View{
    
    let style: ButtonLabelType
    let text: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action){
            Text(LocalizedStringKey(text))
                .font(Fonts.subheading)
                .foregroundColor(style == .outlined ? .primary : .main)
                .padding(.horizontal, LayoutConst.largePadding)
                .padding(.vertical, 18.5)
                .background(backgroundView)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.primary, style: StrokeStyle(lineWidth: style == .outlined ? 1 : 0))
                )
        }
    }
    private var backgroundView: some View {
        switch style {
        case .filled:
            return Color.primary
        case .outlined:
            return Color.main
        }
    }
    
}

