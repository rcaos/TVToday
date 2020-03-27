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
  
  var genreId: Int
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  var showsObservableSubject: BehaviorSubject<SimpleViewState<TVShow>> = .init(value: .loading)
  
  // MARK: - Initializers
  
  init(genreId: Int, fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.genreId = genreId
    shows = []
    cellsmodels = []
    filter = .byGenre(genreId: genreId)
    
    self.input = Input()
    self.output = Output(viewState: showsObservableSubject.asObservable())
  }
  
  // MARK: - Remove from Protocol
  func createModels(for fetched: [TVShow]) {
  }
  
  func getModelFor(_ entity: TVShow) -> TVShowCellViewModel {
    return TVShowCellViewModel(show: entity)
  }
}

// MARK: - ViewModel Base

extension TVShowListViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let viewState: RxSwift.Observable<SimpleViewState<TVShow>>
  }
}