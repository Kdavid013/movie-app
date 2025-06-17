//
//  CastDetailsView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 06. 09..
//

import SwiftUI
import InjectPropertyWrapper


struct CastDetailsView: View {
    
    let castDetailType: CastDetailType
    
    @StateObject private var viewModel = CastDetailsViewModel()
    
    var body: some View {
        ZStack(alignment: .topTrailing){
            HStack{
                Spacer()
                VStack{
                    Image(.circle)
                        .ignoresSafeArea(edges: .top)
                    Spacer()
                }
            }
            
            ScrollView{
                VStack(alignment: .leading,spacing: 20){
                    MoviePicture(picUrl: viewModel.castDetail.imageUrl)
                    Text(viewModel.castDetail.name)
                        .font(Fonts.detailTitle)
                    HStack{
                        DetailLabel(title: "detail.label.birthYear", desc: viewModel.castDetail.birthYear)
                        DetailLabel(title: "detail.label.birthPlace", desc: viewModel.castDetail.originPlace ?? "")
                    }
                    VStack(alignment: .leading,spacing: 12){
                        Text(LocalizedStringKey("detail.bio"))
                            .font(Fonts.overviewText)
                        Text(viewModel.castDetail.biography ?? "")
                            .font(Fonts.paragraph)
                            .lineLimit(5)
                    }
                    VStack{
                        Text(LocalizedStringKey("detail.popularity"))
                            .font(Fonts.overviewText)
                    }
                    
                }
            }
            .padding(.horizontal,LayoutConst.maxPadding)
        }
        .onAppear {
            viewModel.participantTypeSubject.send(castDetailType)
        }
    }
}
