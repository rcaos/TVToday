//
//  SearchSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import UIKit

final class SearchSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeSearchViewController() -> UIViewController {
        return SearchViewController.create( with: makeSearchViewModel(),
                                              searchViewControllersFactory: self)
    }
}

// MARK: - Private

extension SearchSceneDIContainer {
    
    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes
    
    private func makeSearchViewModel() -> SearchViewModel {
        return SearchViewModel(fetchGenresUseCase: makeFetchPopularsShowsUseCase())
    }
    
    // MARK: - Use Cases
    
    private func makeFetchPopularsShowsUseCase() -> FetchGenresUseCase {
        return DefaultFetchGenresUseCase(genresRepository:
            makeGenresRepository())
    }
    
    // MARK: - Repositories
    
    private func makeGenresRepository() -> GenresRepository {
        return DefaultGenreRepository(dataTransferService:
            dependencies.apiDataTransferService)
    }
}

// MARK: - SearchViewControllersFactory

extension SearchSceneDIContainer: SearchViewControllersFactory {
    
}
