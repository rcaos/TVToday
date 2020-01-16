//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

final class AiringTodayViewModel {
    
    private let fetchTodayShowsUseCase: FetchTodayShowsUseCase
    
    var tvShowsCells: [AiringTodayCollectionViewModel] = []
    
    var viewState:Bindable<SimpleViewState<TVShow>> = Bindable(.loading)
    
    var tvShows: [TVShow] {
        return viewState.value.currentEntities
    }
    
    private var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    // MARK: - Initializers
    
    init(fetchTodayShowsUseCase: FetchTodayShowsUseCase) {
        self.fetchTodayShowsUseCase = fetchTodayShowsUseCase
    }
    
    // MARK: - Fetch Shows
    
    func getShows(for page: Int){
        if viewState.value.isInitialPage {
            viewState.value =  .loading
        }
        
        let request = FetchTodayUseCaseRequestValue(page: page)
        
        showsLoadTask = fetchTodayShowsUseCase.execute(requestValue: request) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let results):
                strongSelf.processFetched(for: results)
            case .failure(let error):
                print("Error to fetch Case use \(error)")
            }
        }
    }
    
    func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel{
        return tvShowsCells[index]
    }
    
    // MARK: - Private
    
    private func processFetched(for response: TVShowResult) {
        let fetchedShows = response.results ?? []
        
        tvShowsCells.append(contentsOf: fetchedShows.map({ AiringTodayCollectionViewModel(show: $0) }))
        
        let allShows = viewState.value.currentEntities + fetchedShows
        
        if allShows.isEmpty {
            viewState.value = .empty
            return
        }

        if response.hasMorePages {
            self.viewState.value = .paging(allShows, next: response.nextPage)
        } else {
            self.viewState.value = .populated(allShows)
        }
    }
    
    // MARK: - Build Models
    
    func buildShowDetailViewModel(for showId: Int) -> TVShowDetailViewModel {
        return TVShowDetailViewModel(showId)
    }
}
