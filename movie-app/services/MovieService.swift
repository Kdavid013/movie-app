//
//  MovieService.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 12..
//

import Foundation
import Moya

protocol MovieServiceProtocol{
//    async - aszinkron hivás jelzése a forditónak, await kulcsszó
//    throws - dob hibát, try catch phrasebe kell beletenni
    func fetchGenres(req:FetchGenreRequest) async throws -> [Genre]
}

// konvenció protokol neve végén protocol
class MovieService: MovieServiceProtocol {
    var moya: MoyaProvider<MultiTarget>
    init(){
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        self.moya = MoyaProvider<MultiTarget>(session: Session(
            configuration: configuration,startRequestsImmediately: false),
                                              plugins: [
                                                NetworkLoggerPlugin()
                                              ])
    }
    
    
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
}
