//
//  ResultsSearchViewModelMock.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import Combine
@testable import SearchShows

final class ResultsSearchViewModelMock: ResultsSearchViewModelProtocol {
  func recentSearchIsPicked(query: String) { }
  func showIsPicked(idShow: Int) { }
  func searchShows(with query: String) { }
  func resetSearch() { }

  var viewState: CurrentValueSubject<ResultViewState, Never>
  var dataSource: CurrentValueSubject<[ResultSearchSectionModel], Never>
  weak var delegate: ResultsSearchViewModelDelegate?

  func getViewState() -> ResultViewState {
    return state
  }

  private let state: ResultViewState

  init(state: ResultViewState, source: [ResultSearchSectionModel] = []) {
    self.state = state
    viewState = CurrentValueSubject(state)

    dataSource = CurrentValueSubject(source)
  }
}
