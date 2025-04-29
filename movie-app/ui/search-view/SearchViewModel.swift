//
//  SearchViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import Combine
import InjectPropertyWrapper

protocol SearchViewModelProtocol {
    var movies: [Movie] { get }
    var searchText: String { get set }
    func searchMovies() async
}

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
