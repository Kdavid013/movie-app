//
//  DetailsViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 09..
//

import Foundation
import InjectPropertyWrapper

protocol DetailsViewModelProtocol: ObservableObject {
    var movie: [MediaItem] { get }
    
}

class DetailsViewModel: DetailsViewModelProtocol {
    @Published var movie: [MediaItem]
    
    
    init?() {
        return nil
    }
}
