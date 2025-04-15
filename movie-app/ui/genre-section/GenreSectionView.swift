//
//  ContentView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 08..
//

import SwiftUI
import InjectPropertyWrapper

protocol GenreSectionViewModelProtocol: ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol{
    @Published var genres: [Genre] = []
    
//    private var movieService: MovieServiceProtocol = MovieService()
    @Inject var movieService: MovieServiceProtocol
    
    func fetchGenres() async{
       do {
           let request = FetchGenreRequest()
           let genres = Environment.name  == .tv ? try await movieService.fetchTVGenres(req: request) : try await movieService.fetchGenres(req: request)
//         visszahozza a programot a main threadre, hogy ne blokkolja a UI-t
           DispatchQueue.main.async {
               self.genres = genres
           }
       }
       catch
       {
           print("Error fetching genres: \(error)")
       }
//        self.genres = [
//            Genre(id:1, name: "Adventure"),
//            Genre(id:2, name: "Sci-fi"),
//            Genre(id:3, name: "Fantasy"),
//            Genre(id:4, name: "Comedy"),
//        ]
    }
}

struct GenreSectionView: View {
    
    @StateObject
    private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                VStack{
                    Image(.circle)
                    Spacer()
                }
            }
            HStack{
                NavigationView {
                    List(viewModel.genres){ genre in
                        ZStack{
                            NavigationLink(destination: MovieListView(genre: genre)){
                                EmptyView()
                            }
                            .opacity(0)
                            
                            HStack {
                                Text(genre.name)
                                    .font(Fonts.title)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(.rightArrow)
                            }
                            
                        }.background(Color.clear)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle(Environment.name == .tv ? "TV app":"genreSection.title")
                    .background(Color.clear)
                }            }
            .listStyle(.plain)
        }
        .onAppear {
//          háttérben fut le az async metódus
            Task{
                await viewModel.fetchGenres()
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
