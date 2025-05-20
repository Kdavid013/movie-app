//
//  StarView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import SwiftUI

struct StarView: View {
    let index: Int
    let isFilled: Bool
    let onTap: () -> Void

    var body: some View {
        Image(systemName: isFilled ? "star.fill" : "star")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 40, height: 40)
            .onTapGesture {
                onTap()
            }
    }
}
