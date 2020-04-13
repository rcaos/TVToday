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
  
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var currentSearch = ""
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .populated([]))
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
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
    viewStateObservableSubject.onNext(.populated([]))
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }
}

extension ResultsSearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
  }
}
