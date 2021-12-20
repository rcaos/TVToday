//
//  ResultsSearchViewModelMock.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import RxSwift
@testable import SearchShows

final class ResultsSearchViewModelMock: ResultsSearchViewModelProtocol {
  func recentSearchIsPicked(query: String) { }

  func showIsPicked(idShow: Int) { }

  func searchShows(with query: String) { }

  func resetSearch() { }

  var viewState: Observable<ResultViewState>

  var dataSource: Observable<[ResultSearchSectionModel]>

  weak var delegate: ResultsSearchViewModelDelegate?

  func getViewState() -> ResultViewState {
    return state
  }

  private let state: ResultViewState

  init(state: ResultViewState, source: [ResultSearchSectionModel] = []) {
    self.state = state
    viewState = Observable.just(state)

    dataSource = Observable.just(source)
  }
}
