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
    
    var body: some View {
        NavigationView{
            VStack{
                HStack(spacing: 12.0){
                    Image(.search)
                        .frame(width: 24, height: 24)
                    TextField("",
                              text: $viewModel.searchText,
                              prompt: Text("search.textfield.placeholder")
                        .foregroundStyle(.invertedMain)
                    )
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(Fonts.searchText)
                    .foregroundColor(.invertedMain)
                    .onChange(of: viewModel.searchText) {
                        viewModel.startSearch.send(())
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
                        Text("search.empty.title")
                            .multilineTextAlignment(.center)
                            .font(Fonts.emptyStateText)
                            .foregroundColor(.invertedMain)
                        Spacer()
                    }
                }else{
                    ScrollView{
                        LazyVStack(spacing: LayoutConst.normalPadding){
                            ForEach(viewModel.movies){ movie in
                                MovieCell(movie: movie)
                                    .frame(height: 277)
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
