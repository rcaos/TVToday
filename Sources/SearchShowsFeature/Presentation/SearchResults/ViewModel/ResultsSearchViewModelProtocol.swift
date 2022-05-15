//
//  ResultsSearchViewModelProtocol.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Shared

protocol ResultsSearchViewModelDelegate: AnyObject {
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectShow idShow: Int)

  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectRecentSearch query: String)
}

protocol ResultsSearchViewModelProtocol {
  // MARK: - Input
  func recentSearchIsPicked(query: String)
  func showIsPicked(index: Int)
  func searchShows(with query: String)
  func resetSearch()

  // MARK: - Output
  var viewState: CurrentValueSubject<ResultViewState, Never> { get }
  var dataSource: CurrentValueSubject<[ResultSearchSectionModel], Never> { get }
  var delegate: ResultsSearchViewModelDelegate? { get set }
  func getViewState() -> ResultViewState
}

// MARK: - View State
enum ResultViewState: Equatable {
  case initial
  case empty
  case loading
  case populated
  case error(String)

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
