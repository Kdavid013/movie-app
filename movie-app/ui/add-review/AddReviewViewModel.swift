//
//  AddReviewViewModel.swift
//  movie-app
//
//  Created by David Karacs on 2025. 05. 20..
//

import Foundation
import InjectPropertyWrapper
import Combine


class AddReviewViewModel: ObservableObject, ErrorPresentable {

    @Published
    var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    
    let mediaDetailSubject = PassthroughSubject<MediaItemDetail, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedRating: Int = -1
    
    init(){
        mediaDetailSubject
            .sink{[weak self] detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
    }
    
}
