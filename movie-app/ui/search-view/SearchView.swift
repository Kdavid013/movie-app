//
//  SearchView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI
import InjectPropertyWrapper

struct SearchView: View {
    
    @StateObject
    private var viewModel = SearchViewModel()
    
    @EnvironmentObject
    var languageManager: LanguageManager
    
    @State
    private var isAnimated: [Int] = []
    
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 12.0){
                    Image(.search)
                        .frame(width: 24, height: 24)
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder".localized())
                        .foregroundStyle(.invertedMain)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.caption)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        viewModel.startSearch.send(())
                        isAnimated.removeAll()
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, LayoutConst.normalPadding)
                .background(Color.searchBarForeground)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.invertedMain, lineWidth: 1)
                )
                .cornerRadius(28)
                .padding(.horizontal, LayoutConst.maxPadding)
                
                if viewModel.movies.isEmpty {
                    VStack{
                        Spacer()
                        Text("search.empty.title".localized())
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                }else{
                    ScrollView{
                        LazyVStack(spacing: LayoutConst.normalPadding){
                            ForEach(Array(viewModel.movies.enumerated()), id: \.1.id){ index, mediaItem in
                                NavigationLink(destination: DetailsView(mediaItem: mediaItem)){
                                    MediaItemCell(movie: mediaItem)
                                        .frame(height: 277)
                                        .offset(x: isAnimated.contains(mediaItem.id) ? 0 : 200 )
                                        .opacity(isAnimated.contains(mediaItem.id) ? 1 : 0)
                                        .onAppear {
                                            withAnimation(.easeInOut(duration: 0.5).delay(Double(index) * 0.02)){
                                                isAnimated.append(mediaItem.id)
                                            }
                                        }
                                    
                                }
                                .foregroundColor(.invertedMain)
                            }
                        }
                        .padding(.horizontal, LayoutConst.normalPadding)
                        .padding(.top, LayoutConst.normalPadding)
                    }
                    
                }
            }
        }
    }
}
