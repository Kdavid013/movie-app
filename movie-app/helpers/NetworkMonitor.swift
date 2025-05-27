//
//  NetworkMonitor.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 17..
//

import Foundation
import Reachability
import Combine

protocol NetworkMonitorProtocol {
    var isConnected: AnyPublisher<Bool, Never> { get }
    func networkType() -> String
}
class NewNetworkMonitor: NetworkMonitorProtocol {
    func networkType() -> String {
        return "networkType"
    }
    
    var isConnected: AnyPublisher<Bool, Never>{
        Just(false)
            .eraseToAnyPublisher()
    }
    
    
}

class NetworkMonitor: NetworkMonitorProtocol {
    
    var isConnected: AnyPublisher<Bool, Never>{
        isConnectedSubject
            .eraseToAnyPublisher()
    }
    
    private var reachability: Reachability
    
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(true)
    
    init() {
        guard let reachability = try? Reachability() else {
            fatalError("Failed to initialize Reachability")
        }
        
        self.reachability = reachability
        
        reachability.whenReachable = { [weak self] reachability in
            let available = reachability.connection != .unavailable
            self?.isConnectedSubject.send(available)
        }
        reachability.whenUnreachable = {[weak self] _ in
            self?.isConnectedSubject.send(false)
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        print("<<<<",self)
    }
    
    func networkType() -> String {
        return reachability.connection.description
    }
}
