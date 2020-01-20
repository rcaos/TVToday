//
//  TVShowListSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/20/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class TVShowListSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    public func makeShowListViewController(with identifier: Int) -> UIViewController {
        return TVShowListViewController.create( with: makeShowListViewModel(with: identifier), showsListViewControllersFactory: self)
    }
}

// MARK: - Private

extension TVShowListSceneDIContainer {
    
    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes
    
    private func makeShowListViewModel(with identifier: Int) -> TVShowListViewModel {
        return TVShowListViewModel(genreId: identifier, fetchShowListUseCase: makeShowListUseCase())
    }
    
    // MARK: - Use Cases
    
    private func makeShowListUseCase() -> FetchTVShowsUseCase {
        return DefaultFetchTVShowsUseCase(tvShowsRepository: makeTVShowsRepository())
    }
    
    // MARK: - Repositories
    
    private func makeTVShowsRepository() -> TVShowsRepository {
        return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}

// MARK: - TVShowListViewControllersFactory

extension TVShowListSceneDIContainer: TVShowListViewControllersFactory {
     
    public func makeTVShowDetailsViewController(with identifier: Int) -> UIViewController {
        let showDetailsDependencies = TVShowDetailsSceneDIContainer.Dependencies(
                apiDataTransferService: dependencies.apiDataTransferService,
                imageDataTransferService: dependencies.imageDataTransferService)
            
        let container =  TVShowDetailsSceneDIContainer(dependencies: showDetailsDependencies)
        
        return container.makeTVShowDetailsViewController(with: identifier)
    }
}
