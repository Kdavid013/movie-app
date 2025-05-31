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

enum ButtonLabelAction{
    case simple
    case link(_ url: URL?)
}

struct ButtonLabel: View{
    
    let style: ButtonLabelType
    let title: String
    let action: ButtonLabelAction
    
    var body: some View {
        
        baseView
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
//            .frame(maxWidth: .infinity)
    }

@ViewBuilder
private var baseView: some View {
    switch action {
    case .simple:
        Text(LocalizedStringKey(title))
    case .link(let url):
        if let url = url {
            Link(LocalizedStringKey(title), destination: url)
        } else {
            Text(LocalizedStringKey(title))
        }
        
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

