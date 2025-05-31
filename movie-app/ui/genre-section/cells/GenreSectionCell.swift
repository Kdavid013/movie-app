//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell: View {
    var genre: Genre
    @State
    var isExpanded: Bool = false

    var body: some View {
        HStack {
            Text(genre.name)
                .font(Fonts.title)
                .foregroundStyle(.primary)
            Spacer()
            RotatingArrow(isExpanded: isExpanded)
                .onTapGesture {
                    isExpanded.toggle()
                }
        }
    }
}
