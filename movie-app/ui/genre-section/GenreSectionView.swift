//
//  ContentView.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 08..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    private var movieService: MovieServiceProtocol = MovieService()
    
    func fetchGenres() async{
       do {
           let request = FetchGenreRequest()
           let genres = try await movieService.fetchGenres(req: request)
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
    
    @StateObject private var viewModel = GenreSectionViewModel()
    
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
                            NavigationLink(destination: Color.gray){
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
                    .navigationTitle("genreSection.title")
                    .background(Color.clear)
                }            }
            .listStyle(.plain)
            .navigationTitle(Environment.name == .dev ? "DEV":"PROD")
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
