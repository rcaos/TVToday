//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

final class TVShowListViewModel: ShowsViewModel {
    
    var fetchTVShowsUseCase: FetchTVShowsUseCase
    
    var filter: TVShowsListFilter
    var viewState:Observable<SimpleViewState<TVShow>> = Observable(.loading)
    
    var shows: [TVShow]
    var cellsmodels: [TVShowCellViewModel]
    
    var showsLoadTask: Cancellable? {
        willSet {
            showsLoadTask?.cancel()
        }
    }
    
    var genreId: Int!
  
  var showsObservableSubject: BehaviorSubject<SimpleViewState<TVShow>> = .init(value: .loading)
    
    // MARK: - Initializers
    
    init(genreId: Int, fetchTVShowsUseCase: FetchTVShowsUseCase) {
        self.fetchTVShowsUseCase = fetchTVShowsUseCase
        self.genreId = genreId
        shows = []
        cellsmodels = []
        filter = .byGenre(genreId: genreId)
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
