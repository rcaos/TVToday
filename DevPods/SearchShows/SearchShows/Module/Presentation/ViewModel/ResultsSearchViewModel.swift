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

protocol ResultsSearchViewModelDelegate: class {
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel, didSelectShow idShow: Int)
}

final class ResultsSearchViewModel {
  
  weak var delegate: ResultsSearchViewModelDelegate?
  
  private let fetchTVShowsUseCase: SearchTVShowsUseCase
  
  private let fetchRecentSearchsUseCase: FetchSearchsUseCase
  
  private let dataSourceObservableSubject = BehaviorSubject<[ResultSearchSectionModel]>(value: [])
  
  private var viewStateObservableSubject: BehaviorSubject<ViewState> = .init(value: .initial)
  
  private var shows: [TVShow]
  
  private var showsCells: [TVShowCellViewModel] = []
  
  private var currentSearch = ""
  
  private var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchsUseCase: FetchSearchsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.fetchRecentSearchsUseCase = fetchRecentSearchsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable(),
                         dataSource: dataSourceObservableSubject.asObservable())
    
    subscribeToSearchs()
  }
  
  // MARK: - Public
  
  func showIsPicked(idShow: Int) {
    delegate?.resultsSearchViewModel(self, didSelectShow: idShow)
  }
  
  // 1
  func clearShows() {
    shows.removeAll()
  }
  
  // 2
  func searchShows(with query: String) {
    guard !query.isEmpty else { return }
    
    currentSearch = query
    searchShows()
  }
  
  // 3
  func resetSearch() {
    clearShows()
    viewStateObservableSubject.onNext(.initial)
  }
  
  // MARK: - Private
  
  private func fetchRecentsShows() -> Observable<[Search]> {
    return fetchRecentSearchsUseCase.execute(requestValue: FetchSearchsUseCaseRequestValue())
  }
  
  private func subscribeToSearchs() {
    viewStateObservableSubject
      .distinctUntilChanged()
      .filter { $0 == .initial }
      .flatMap { [weak self] _ -> Observable<[Search]> in
        guard let strongSelf = self else { return Observable.just([])}
        return strongSelf.fetchRecentsShows()
    }
    .subscribe(onNext: { [weak self] results in
      self?.createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
    })
      .disposed(by: disposeBag)
  }
  
  // MARK: - TODO, refator the next 2 methods
  
  func searchShows() {
    guard !currentSearch.isEmpty else { return }
    getShows(query: currentSearch )
  }
  
  private func getShows(query: String) {
    
    viewStateObservableSubject.onNext(.loading)
    
    let request = SearchTVShowsUseCaseRequestValue(query: query, page: 1)
    
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
    let cellsShows = mapToCell(entites: shows)
    
    if self.shows.isEmpty {
      viewStateObservableSubject.onNext(.empty)
    } else {
      viewStateObservableSubject.onNext( .populated(cellsShows) )
    }
    
    createSectionModel(recentSearchs: [], resultShows: cellsShows)
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
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
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<ViewState>
    let dataSource: Observable<[ResultSearchSectionModel]>
  }
}

extension ResultsSearchViewModel {
  
  enum ViewState: Equatable {
    case
    initial,
    
    empty,
    
    loading,
    
    populated([TVShowCellViewModel]),
    
    error(String)
    
    static func == (lhs: ResultsSearchViewModel.ViewState, rhs: ResultsSearchViewModel.ViewState) -> Bool {
      switch (lhs, rhs) {
        
      case (.initial, .initial):
        return true
        
      case (.empty, .empty):
        return true
        
      case (.loading, .loading):
        return true
        
      case (let .populated(lhsShows), let .populated(rhsShows)):
        return lhsShows.map { $0.entity.id } == rhsShows.map { $0.entity.id }
        
      case (.error, .error):
        return true
        
      default:
        return false
      }
    }
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
