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
    var movies: [MediaItem] { get }
    var searchText: String { get set }
    func searchMovies() async
}

class SearchViewModel:  ObservableObject, ErrorPresentable{
    @Published var movies: [MediaItem] = []
    @Published var searchText: String = ""
    
    let startSearch = PassthroughSubject<Void, Never>()
    
    @Published var alertModel: AlertModel? = nil
    @Inject
    private var repository: MovieRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        startSearch
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .flatMap{ _ -> AnyPublisher<[MediaItem], MovieError> in
                
                
                let request = SearchMediaItemRequest(query: self.searchText)
                return Environments.name == .tv ? self.repository.searchTvs(req: request) : self.repository.searchMovies(req: request)
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: {[weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
