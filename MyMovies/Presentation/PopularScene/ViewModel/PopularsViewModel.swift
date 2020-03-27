//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

final class PopularViewModel: ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var filter: TVShowsListFilter = .popular
  var viewState:Observable<SimpleViewState<TVShow>> = Observable(.loading)
  
  var shows: [TVShow]
  var cellsmodels: [TVShowCellViewModel]
  
  var showsLoadTask: Cancellable? {
    willSet {
      showsLoadTask?.cancel()
    }
  }
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  var showsObservableSubject: BehaviorSubject<SimpleViewState<TVShow>> = .init(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    cellsmodels = []
    
    self.input = Input()
    self.output = Output(shows: showsObservableSubject.asObservable())
  }
  
  // MARK: - TODO, Remove from protocol
  func createModels(for fetched: [TVShow]) {
  }
  
  func getModelFor(_ entity: TVShow) -> TVShowCellViewModel {
    return TVShowCellViewModel(show: entity)
  }
}

// MARK: - ViewModel Base

extension PopularViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let shows: RxSwift.Observable<SimpleViewState<TVShow>>
  }
}

