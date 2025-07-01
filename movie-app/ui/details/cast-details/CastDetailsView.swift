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
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
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
                        DetailLabel(title: "detail.label.birthYear".localized(), desc: viewModel.castDetail.birthYear)
                        DetailLabel(title: "detail.label.birthPlace".localized(), desc: viewModel.castDetail.originPlace ?? "")
                    }
                    VStack(alignment: .leading,spacing: 12){
                        Text(LocalizedStringKey("detail.bio".localized()))
                            .font(Fonts.overviewText)
                        Text(viewModel.castDetail.biography ?? "")
                            .font(Fonts.paragraph)
                            .lineLimit(5)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("detail.lable.popularity".localized())
                            .font(Fonts.overviewText)
                            .foregroundColor(Color.primary)
                        HStack {
                            Spacer()
                            StarRatingView(rating: $viewModel.rating, starSize: 24)
                                .allowsHitTesting(false)
                            Spacer()
                        }
                    }
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(viewModel.combinedCredits){ mediaItem in
                            NavigationLink(destination: DetailsView(mediaItem: mediaItem)){
                                MediaItemCell(movie: mediaItem)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
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
