//
//  MovieListViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 29..
//
import Foundation
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject{
    var movies: [MediaItem] { get }
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    
    @Published var movies: [MediaItem] = []
    
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    @Inject
    private var repository: MovieRepository
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    init(){
        
        genreIdSubject
            .flatMap { [weak self] genreId -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                
                let request = FetchMoviesRequest(genreId: genreId)
                return Environments.name == .tv ?
                self.repository.fetchSeries(req: request):
                self.repository.fetchMovies(req: request)
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
    
    //    func loadSeries(by genreId:Int) async {
    //        do {
    //            let request = FetchSeriesRequest(genreId: genreId)
    //            let series = try await service.fetchSeries(req: request)
    //            DispatchQueue.main.async {
    //                self.series = series
    //            }
    //        } catch {
    //            print("Error fetching genres: \(error)")
    //        }
    //    }
    
}

