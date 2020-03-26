//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayViewModel: ShowsViewModel {
    
    var fetchTVShowsUseCase: FetchTVShowsUseCase
    
    var filter: TVShowsListFilter = .today
    var viewState:Observable<SimpleViewState<TVShow>> = Observable(.loading)
    
    var shows: [TVShow]
    var cellsmodels: [AiringTodayCollectionViewModel]
    
    var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    // MARK: - Initializers
    
    init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
        self.fetchTVShowsUseCase = fetchTVShowsUseCase
        shows = []
        cellsmodels = []
    }
    
    func createModels(for fetched: [TVShow]) {
        self.cellsmodels.append(contentsOf:
            fetched.map { AiringTodayCollectionViewModel(show: $0) })
    }
    
    func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel {
        return cellsmodels[index]
    }
}
