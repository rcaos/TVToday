//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

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
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  var showsObservableSubject = BehaviorSubject<SimpleViewState<TVShow>>(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    cellsmodels = []
    
    self.input = Input()
    self.output = Output(shows: showsObservableSubject.asObservable())
  }
  
  func createModels(for fetched: [TVShow]) {
    self.cellsmodels.append(contentsOf:
      fetched.map { AiringTodayCollectionViewModel(show: $0) })
  }
  
  func getModelFor(_ index:Int) -> AiringTodayCollectionViewModel {
    return cellsmodels[index]
  }
}

// MARK: - ViewModel Base

extension AiringTodayViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let shows: RxSwift.Observable<SimpleViewState<TVShow>>
  }
}
