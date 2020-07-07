//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import Shared
import Persistence

final class ResultsSearchViewModel {
  
  var fetchTVShowsUseCase: SearchTVShowsUseCase
  
  private let fetchSearchsUseCase: FetchSearchsUseCase
  
  private let dataSourceObservableSubject = BehaviorSubject<[ResultSearchSectionModel]>(value: [])
  
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var currentSearch = ""
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .populated([]))
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: SearchTVShowsUseCase,
       fetchSearchsUseCase: FetchSearchsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.fetchSearchsUseCase = fetchSearchsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable(),
                         dataSource: dataSourceObservableSubject.asObservable())
    
    subscribeToSearchs()
  }
  
  deinit {
    print("deinit ResultsSearchViewModel")
  }
  
  private func subscribeToSearchs() {
    fetchSearchsUseCase.execute(requestValue: FetchSearchsUseCaseRequestValue())
      .debug()
      .subscribe(onNext: { [weak self] results in
        self?.viewStateObservableSubject.onNext( .populated([]) )
        self?.createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - TODO, refator the next 2 methods
  
  func searchShows(for query: String, page: Int) {
    guard !query.isEmpty else { return }
    
    currentSearch = query
    searchShows(for: page)
  }
  
  func searchShows(for page: Int) {
    guard !currentSearch.isEmpty else { return }
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
    
    createSectionModel(recentSearchs: [], resultShows: cellsShows)
  }
  
  fileprivate func createSectionModel(recentSearchs: [String], resultShows: [TVShowCellViewModel]) {
    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }
    let resultsShowsItem = resultShows.map { ResultSearchSectionItem.results(items: $0) }
    
    let dataSource: [ResultSearchSectionModel] = [
      .recentSearchs(header: "Recent Searchs", items: recentSearchsItem),
      .results(header: "Results Shows", items: resultsShowsItem)
    ]
    dataSourceObservableSubject.onNext(dataSource)
  }
}

extension ResultsSearchViewModel {
  
  public struct Input {
  }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
    let dataSource: Observable<[ResultSearchSectionModel]>
  }
}

// MARK: - Refactor this

enum ResultSearchSectionModel {
  case
  recentSearchs(header: String, items: [ResultSearchSectionItem]),
  results(header: String, items: [ResultSearchSectionItem])
}

enum ResultSearchSectionItem {
  case
  recentSearchs(items: String),
  results(items: TVShowCellViewModel)
}

extension ResultSearchSectionModel: SectionModelType {
  
  typealias Item =  ResultSearchSectionItem
  
  var items: [ResultSearchSectionItem] {
    switch self {
    case .recentSearchs(_, items: let items):
      return items
    case .results(_, items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .recentSearchs(header: let header, items: _):
      self = .recentSearchs(header: header, items: items)
    case .results(header: let header, items: _):
      self = .results(header: header, items: items)
    }
  }
  
}
