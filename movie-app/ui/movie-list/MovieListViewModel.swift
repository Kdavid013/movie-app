//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper

protocol MovieListViewModelProtocol: ObservableObject{
    var movies: [Movie] { get }
    func loadMovies(by genreId: Int) async
}

class MovieListViewModel: MovieListViewModelProtocol {
    
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MovieServiceProtocol
    
    func loadMovies(by genreId: Int) async {
        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let movies = try await service.fetchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

