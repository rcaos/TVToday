//
//  TVShowsSceneDIContainer.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

final class TodayShowsSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
        let imageDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Initializers
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeAiringTodayViewController() -> UIViewController {
        return AiringTodayViewController.create( with: makeAiringTodayViewModel(),
                                                 airingTodayViewControllersFactory: self)
    }
}

// MARK: - Private

extension TodayShowsSceneDIContainer {
    
    // MARK: - TODO cambiar ViewModel por protocolm, Agregar repository de Imágenes
    
    private func makeAiringTodayViewModel() -> AiringTodayViewModel {
        return AiringTodayViewModel(fetchTodayShowsUseCase: makeFetchTodayShowsUseCase())
    }
    
    // MARK: - Use Cases
    
    private func makeFetchTodayShowsUseCase() -> FetchTodayShowsUseCase {
        return DefaultFetchTodayShowsUseCase(tvShowsRepository: makeTVShowsRepository())
    }
    
    // MARK: - Repositories
    
    private func makeTVShowsRepository() -> TVShowsRepository {
        return DefaultTVShowsRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}

// MARK: - AiringTodayViewControllersFactory

extension TodayShowsSceneDIContainer: AiringTodayViewControllersFactory {
    
}
