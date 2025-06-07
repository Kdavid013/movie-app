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
    @Published var isLoading: Bool = false
    
    var actualPage: Int = 0
    var totalPages: Int = 500
    
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    @Inject
    private var repository: MovieRepository
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    init(){
        
        genreIdSubject
            .filter{[weak self] _ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.actualPage < self.totalPages
            }
            .handleEvents(receiveOutput:{ [weak self]_ in
                self?.isLoading = true
                self?.actualPage += 1
            })
            .flatMap { [weak self] genreId -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMoviesRequest(genreId: genreId, page: actualPage)
                return self.repository.fetchMovies(req: request)
            }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            } receiveValue: {[weak self] mediaItemPage in
                if mediaItemPage.totalPages < 500 {
                    self?.totalPages = mediaItemPage.totalPages
                }
                self?.movies.append(contentsOf: mediaItemPage.mediaItems)
                self?.isLoading = false
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

