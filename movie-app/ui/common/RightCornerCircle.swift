//
//  RightCornerCircle.swift
//  movie-app
//
//  Created by David Karacs on 2025. 07. 05..
//

import SwiftUI

struct RightCornerCircle: View {
    var body : some View {
        HStack{
            Spacer()
            VStack{
                Image(.circle)
                    .ignoresSafeArea(edges: .top)
                Spacer()
            }
        }
    }
}
