//
//  ButtonLabel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//
import SwiftUI

struct ButtonLabel: View{
    
    let text: Text
    
    var body: some View {
        
        return HStack{
            text
                .font(Fonts.subheading)
        }
        .frame(height: 56)
        .padding(.horizontal, LayoutConst.largePadding)
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.invertedMain, lineWidth: 1)
            )
        .cornerRadius(28)
    }
    
    
}

