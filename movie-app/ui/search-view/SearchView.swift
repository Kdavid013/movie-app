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
        VStack{
            HStack{
                Image(.search)
                TextField("search.textfield.placeholder", text:  $viewModel.searchText)
                    .padding([.top,.bottom],21)
                    .font(Fonts.paragraph)
            }
            .padding(.horizontal, 15)
            .background(Color.white.opacity(0.5),in: RoundedRectangle(cornerRadius: 50).stroke(style: StrokeStyle(lineWidth: 2)))
            .background(Color.white.opacity(0.15),in: RoundedRectangle(cornerRadius: 50))
            .padding(.horizontal, 10)
            .onChange(of: viewModel.searchText){
                _ in Task{
                    await viewModel.searchMovies()
                }
            }
            
            if viewModel.movies.isEmpty {
                Spacer()
                Text("search.empty.title")
                    .font(Fonts.title)
                Spacer()
            }else{
                ScrollView{
                    VStack(spacing:10){
                        ForEach(viewModel.movies){
                            movie in MovieCellView(movie: movie)
                                .frame(height: 277)
                        }
                    }
                    .padding(.horizontal,16)
                    .padding(.top, 16)
                }
            }
        }
        }
    }


#Preview {
    MainTabView()
}
