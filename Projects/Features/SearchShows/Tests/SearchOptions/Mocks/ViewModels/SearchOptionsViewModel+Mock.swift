//
//  SearchOptionsViewModel+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import SearchShows
@testable import Shared

final class SearchOptionsViewModelMock: SearchOptionsViewModelProtocol {
  func viewDidLoad() { }

  func modelIsPicked(with item: SearchSectionItem) { }

  var viewState: Observable<SearchViewState>

  var dataSource: Observable<[SearchOptionsSectionModel]>

  var viewStateObservableSubject: BehaviorSubject<SearchViewState>

  var dataSourceSubject: BehaviorSubject<[SearchOptionsSectionModel]>

  init(state: SearchViewState, sections: [SearchOptionsSectionModel] = []) {
    viewStateObservableSubject = BehaviorSubject(value: state)
    viewState = viewStateObservableSubject.asObservable()

    dataSourceSubject = BehaviorSubject(value: sections)
    dataSource = dataSourceSubject.asObservable()
  }

  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModelProtocol,
                            didSelectRecentlyVisitedShow id: Int) {
  }
}
