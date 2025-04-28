//
//  SearchView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 22..
//

import SwiftUI
import InjectPropertyWrapper

//protocol SearchViewModelProtocol: @ObservableObject{
//    
//}

class SearchViewModel:  ObservableObject{
    @Published var movies: [Movie] = []
    @Published var searchText: String = ""
    
    @Inject
    private var service: MovieServiceProtocol
    
    func searchMovies() async {
        
        guard !searchText.isEmpty else {
            DispatchQueue.main.async {
                self.movies = []
            }
            return
        }
        
        do {
            let request = SearchMovieRequest(query: searchText)
            let movies = try await service.searchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

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
                        Task{
                            await viewModel.searchMovies()
                        }
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
