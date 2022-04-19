//
//  SearchOptionsViewModel+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
@testable import SearchShows
@testable import Shared

final class SearchOptionsViewModelMock: SearchOptionsViewModelProtocol {
  func viewDidLoad() { }
  func modelIsPicked(with item: SearchSectionItem) { }

  var viewState: CurrentValueSubject<SearchViewState, Never>
  var dataSource: CurrentValueSubject<[SearchOptionsSectionModel], Never>

  init(state: SearchViewState, sections: [SearchOptionsSectionModel] = []) {
    viewState = CurrentValueSubject(state)
    dataSource = CurrentValueSubject(sections)
  }

  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModelProtocol,
                            didSelectRecentlyVisitedShow id: Int) {
  }
}
