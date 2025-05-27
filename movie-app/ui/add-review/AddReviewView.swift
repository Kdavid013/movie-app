//
//  AddReviewView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import SwiftUI
import InjectPropertyWrapper


struct AddReviewView: View {
    
    let mediaItemDetail: MediaItemDetail
    
    @StateObject private var viewModel = AddReviewViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.normalPadding){
            MediaItemHeaderView(title: viewModel.mediaItemDetail.title, year: viewModel.mediaItemDetail.year, runtime: "\(viewModel.mediaItemDetail.runtime)", language: viewModel.mediaItemDetail.spokenLanguages)
                
            MoviePicture(picUrl: viewModel.mediaItemDetail.imageUrl)
            Text(LocalizedStringKey("review.title"))
                .font(Fonts.detailTitle)
            HStack{
                Spacer()
                VStack(spacing: 72.0){
                    StarRatingView(rating: $viewModel.selectedRating)
//                    ButtonLabel(style: .filled, title: "review.button", action:
//                                
//                    )
                }
                Spacer()
            }
        }
        .onAppear{
            viewModel.mediaDetailSubject.send(mediaItemDetail)
        }
        .padding(.horizontal, LayoutConst.maxPadding)
    }
}
