//
//  ServiceAssembly.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//
import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MoyaProvider<MultiTarget>.self) { _ in
            let configuration = URLSessionConfiguration.ephemeral
            configuration.headers = .default
            
            return MoyaProvider<MultiTarget>(
                session: Session(configuration: configuration,
                                 startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin(
                        configuration: NetworkLoggerPlugin.Configuration(
                            output: { _, items in
                                items.forEach { item in
                                    print("Response \(item)")
                                }
                            },
                            logOptions: [.verbose, .requestBody]))
                ])
        }.inObjectScope(.container)
        
        container.register(MovieServiceProtocol.self) { _ in
            return MovieService()
            //            return MockMoviesService()
        }.inObjectScope(.container)
        
        container.register(MovieRepository.self) { _ in
            return MovieRepositoryImpl()
        }.inObjectScope(.transient)
        
        container.register(FavoriteMediaStoreProtocol.self) { _ in
            return FavoriteMediaStore()
        }.inObjectScope(.container)
        
        container.register(MediaItemStoreProtocol.self) { _ in
            return MediaItemStore()
        }.inObjectScope(.container)
        
        container.register(NetworkMonitorProtocol.self, name: "default") { _ in
            return NetworkMonitor()
        }.inObjectScope(.container)
        
        container.register(NetworkMonitorProtocol.self, name: "new") { _ in
            return NewNetworkMonitor()
        }.inObjectScope(.container)
        
        container.register(MediaItemDetailStoreProtocol.self) { _ in
            return MediaItemDetailStore()
        }.inObjectScope(.container)
        
        container.register(CastMemberStoreProtocol.self) { _ in
            return CastMemberStore()
        }.inObjectScope(.container)
        
        container.register(GenreSectionUseCase.self) { _ in
            return GenreSectionUseCaseImpl()
        }.inObjectScope(.container)
        
        container.register(AppVersionProviderProtocol.self) { _ in
            return AppVersionProvider()
        }.inObjectScope(.container)
        
        container.register(ReviewStoreProtocol.self) { _ in
            return ReviewStore()
        }.inObjectScope(.container)
    }
}
