//
//  PopularShowsSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/16/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import UIKit

final class PopularShowsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makePopularsViewController() -> UIViewController {
        return PopularsViewController.create( with: makePopularsViewModel(),
                                              popularsViewControllersFactory: self)
    }
}

// MARK: - Private

extension PopularShowsSceneDIContainer {
    
    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes
    
    private func makePopularsViewModel() -> PopularViewModel {
        return PopularViewModel(fetchPopularsShowsUseCase: makeFetchPopularsShowsUseCase())
    }
    
    // MARK: - Use Cases
    
    private func makeFetchPopularsShowsUseCase() -> FetchTVShowsUseCase {
        return DefaultFetchTVShowsUseCase(tvShowsRepository: makeTVShowsRepository())
    }
    
    // MARK: - Repositories
    
    private func makeTVShowsRepository() -> TVShowsRepository {
        return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}

// MARK: - PopularsViewControllersFactory

extension PopularShowsSceneDIContainer: PopularsViewControllersFactory {
    
}
