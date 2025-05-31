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
    
    let ratingBtnSubject = PassthroughSubject<Void, Never>()
    
    @Inject
    private var repository: MovieRepository
    
    
    private var cancellables = Set<AnyCancellable>()
    @Published var selectedRating: Int = -1
    
    init(){
        mediaDetailSubject
            .sink{[weak self] detail in
                self?.mediaItemDetail = detail
            }
            .store(in: &cancellables)
        
        ratingBtnSubject
            .flatMap { [weak self] _ -> AnyPublisher<ModifyMediaResult, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let rating = Double(self.selectedRating)
                let request = AddReviewRequest(mediaId: mediaItemDetail.id, rating: rating)
                
                return self.repository.addReview(req: request)
            }
            .sink(receiveCompletion: { _ in
                
            }
            , receiveValue: { result in
                
            })
            .store(in: &cancellables)
    }
    
}
