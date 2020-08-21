//
//  ResultsSearchViewModelProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
import Shared

protocol ResultsSearchViewModelDelegate: class {
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectShow idShow: Int)
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectRecentSearch query: String)
}

protocol ResultsSearchViewModelProtocol {
  
  // MARK: - Input
  
  func recentSearchIsPicked(query: String)
  
  func showIsPicked(idShow: Int)
  
  func searchShows(with query: String)
  
  func resetSearch()
  
  // MARK: - Output
  
  var viewState: Observable<ResultViewState> { get }
  
  var dataSource: Observable<[ResultSearchSectionModel]> { get }
  
  var delegate: ResultsSearchViewModelDelegate? { get set }
  
  func getViewState() -> ResultViewState
}

// MARK: - View State

enum ResultViewState: Equatable {
  case
  initial,
  
  empty,
  
  loading,
  
  populated,
  
  error(String)
  
  static func == (lhs: ResultViewState, rhs: ResultViewState) -> Bool {
    switch (lhs, rhs) {
      
    case (.initial, .initial):
      return true
      
    case (.empty, .empty):
      return true
      
    case (.loading, .loading):
      return true
      
    case (.populated, .populated):
      return true
      
    case (.error, .error):
      return true
      
    default:
      return false
    }
  }
}
