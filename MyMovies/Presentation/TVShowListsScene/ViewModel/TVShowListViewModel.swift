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
  
  var shows: [TVShow]
  
  var showsLoadTask: Cancellable? {
    willSet {
      showsLoadTask?.cancel()
    }
  }
  
  var genreId: Int
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShow>> = .init(value: .loading)
  
  // MARK: - Initializers
  
  init(genreId: Int, fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.genreId = genreId
    shows = []
    filter = .byGenre(genreId: genreId)
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func getModelFor(_ entity: TVShow) -> TVShowCellViewModel {
    return TVShowCellViewModel(show: entity)
  }
}

// MARK: - ViewModel Base

extension TVShowListViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShow>>
  }
}
