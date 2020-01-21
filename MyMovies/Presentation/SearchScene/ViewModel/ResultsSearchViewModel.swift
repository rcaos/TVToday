//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class ResultsSearchViewModel: ShowsViewModel {
    
    var fetchTVShowsUseCase: FetchTVShowsUseCase
    
    var filter: TVShowsListFilter = .search(query: "")
    var viewState:Observable<SimpleViewState<TVShow>> = Observable(.loading)
    
    var shows: [TVShow]
    var cellsmodels: [TVShowCellViewModel]
    
    var currentSearch = ""
    
    var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
        self.fetchTVShowsUseCase = fetchTVShowsUseCase
        shows = []
        cellsmodels = []
    }
    
    func searchShows(for query: String, page: Int) {
        guard !query.isEmpty else { return }
        
        currentSearch = query
        searchShows(for: page)
    }
    
    func searchShows(for page: Int) {
        guard !currentSearch.isEmpty else { return }
        
        filter = .search(query: currentSearch)
        
        getShows(for: page)
    }
    
    func clearShows() {
        shows.removeAll()
        cellsmodels.removeAll()
        viewState.value = .populated(shows)
    }
    
    func createModels(for fetched: [TVShow]) {
        self.cellsmodels.append(contentsOf:
            fetched.map({
                TVShowCellViewModel(show: $0)
        }))
    }
    
    func getModelFor(_ index:Int) -> TVShowCellViewModel {
        return cellsmodels[index]
    }
}
