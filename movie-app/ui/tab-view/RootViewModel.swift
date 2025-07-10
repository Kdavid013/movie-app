//
//  RootViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 17..
//

import Foundation
import InjectPropertyWrapper
import Combine

class RootViewModel: ObservableObject {
    
    @Inject(name: "default")
    private var networkMonitor: NetworkMonitorProtocol
    
    @Published var isBannerAppear: Bool = false
    
    @Published var cancellables = Set<AnyCancellable>()
    
    init() {
        networkMonitor.isConnected
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isConnected in
                if !isConnected{
                    self?.isBannerAppear = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.isBannerAppear = false
                    }
                }
            })
            .store(in: &cancellables)
        
    }
}
