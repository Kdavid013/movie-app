//
//  ViewModelAssembly.swift
//  movie-app
//
//  Created by David Karacs on 2025. 04. 15..
//

import Swinject
import Foundation

class ViewModelAssembly: Assembly {

    func assemble(container: Container) {
        container.register((any MediaItemListViewModelProtocol).self) { _ in
            return MediaItemListViewModel()
        }.inObjectScope(.container)
        container.register((any GenreSectionViewModel).self) { _ in
            return GenreSectionViewModelImpl()
        }.inObjectScope(.container)
    }
}
