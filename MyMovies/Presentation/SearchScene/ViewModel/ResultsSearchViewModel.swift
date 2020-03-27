//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

final class ResultsSearchViewModel: ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var filter: TVShowsListFilter = .search(query: "")
  var viewState: Observable<SimpleViewState<TVShow>> = Observable(.loading)
  
  var shows: [TVShow]
  var cellsmodels: [TVShowCellViewModel] = [] // MARK: - TODO Quitar de Protocol
  
  var currentSearch = ""
  
  var showsLoadTask: Cancellable? {
    willSet {
      showsLoadTask?.cancel()
    }
  }
  
  var input: Input
  var output: Output
  
  var showsObservableSubject: BehaviorSubject<SimpleViewState<TVShow>> = .init(value: .populated([]))
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    cellsmodels = []
    
    self.input = Input()
    self.output = Output(viewState: showsObservableSubject.asObservable())
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
    showsObservableSubject.onNext(.populated([]))
  }
  
  // MARK: - TODO remove from protocol
  func createModels(for fetched: [TVShow]) {
    
  }
  
  func getModelFor(entity: TVShow) -> TVShowCellViewModel {
    return TVShowCellViewModel(show: entity)
  }
}

extension ResultsSearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let viewState: RxSwift.Observable<SimpleViewState<TVShow>>
  }
}
