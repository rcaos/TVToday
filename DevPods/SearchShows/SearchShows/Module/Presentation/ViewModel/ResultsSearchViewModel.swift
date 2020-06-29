//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import Shared

final class ResultsSearchViewModel {
  
  var fetchTVShowsUseCase: SearchTVShowsUseCase
    
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var currentSearch = ""
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .populated([]))
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: SearchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  // MARK: - TODO, refator this 2 methods
  
  func searchShows(for query: String, page: Int) {
    guard !query.isEmpty else { return }
    
    currentSearch = query
    searchShows(for: page)
  }
  
  func searchShows(for page: Int) {
    guard !currentSearch.isEmpty else { return }
    
//    filter = .search(query: currentSearch)
    
    getShows(query: currentSearch, for: page)
  }
  
  func clearShows() {
    viewStateObservableSubject.onNext(.populated([]))
    shows.removeAll()
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }
  
  // MARK: - Private
  
  private func getShows(query: String, for page: Int) {
    
    if let state = try? viewStateObservableSubject.value(), state.isInitialPage {
      viewStateObservableSubject.onNext(.loading)
    }
    
    let request = SearchTVShowsUseCaseRequestValue(query: query, page: page)
    
    fetchTVShowsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: result)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
      })
      .disposed(by: disposeBag)
  }
  
  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []
    
    self.shows.append(contentsOf: fetchedShows)
    
    if self.shows.isEmpty ||
      (fetchedShows.isEmpty && response.page == 1) {
      viewStateObservableSubject.onNext(.empty)
      return
    }
    
    let cellsShows = mapToCell(entites: shows)
    
    // MARK: For test only, 3 pages, simulated Ended List.
    let isEnded = response.nextPage < 4
    
    if response.hasMorePages && isEnded {
      viewStateObservableSubject.onNext( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.onNext( .populated(cellsShows) )
    }
  }
}

extension ResultsSearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
  }
}
