//
//  MovieService.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation
import Moya
import InjectPropertyWrapper

protocol MovieServiceProtocol{
//    async - aszinkron hivás jelzése a forditónak, await kulcsszó
//    throws - dob hibát, try catch phrasebe kell beletenni
    func fetchGenres(req:FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req:FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req:FetchMoviesRequest) async throws -> [Movie]
}

// konvenció protokol neve végén protocol
class MovieService: MovieServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req:FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
//            a fetch genre request api végpontja van átadva
                moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
//            result része response = válasz, moyaerror = ha errort ad
                        switch result {
//                      ha  sikeres response a paraméter, responset json decoderrel dekodoljuk
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                                
//                                var genres = [Genre]()
//                                for genreResponse in decodedResponse.genres {
//                                    genres.append(Genre(dto: genreResponse))
//                                }
                                
                                let genres = decodedResponse.genres.map{ genreResponse in
                                    Genre(dto: genreResponse)
                                }
                                
                                continuation.resume(returning: genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
            return try await withCheckedThrowingContinuation { continuation in
                moya.request(MultiTarget(MoviesApi.fetchMovies(req: req))) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResponse = try JSONDecoder().decode(MoviePageResponse.self, from: response.data)
                            let movies = decodedResponse.results.map { Movie(dto: $0) }
                            continuation.resume(returning: movies)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    
    func fetchTVGenres(req:FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
//            a fetch genre request api végpontja van átadva
                moya.request(MultiTarget(MoviesApi.fetchTVGenres(req: req))) { result in
//            result része response = válasz, moyaerror = ha errort ad
                        switch result {
//                      ha  sikeres response a paraméter, responset json decoderrel dekodoljuk
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                                
//                                var genres = [Genre]()
//                                for genreResponse in decodedResponse.genres {
//                                    genres.append(Genre(dto: genreResponse))
//                                }
                                
                                let genres = decodedResponse.genres.map{ genreResponse in
                                    Genre(dto: genreResponse)
                                }
                                
                                continuation.resume(returning: genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
}
