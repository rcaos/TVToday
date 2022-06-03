//
//  PopularViewModel+Mock.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Shared
import UI
@testable import PopularsFeature

class PopularViewModelMock: PopularViewModelProtocol {

  func viewDidLoad() { }

  func willDisplayRow(_ row: Int, outOf totalRows: Int) { }

  func showIsPicked(index: Int) { }

  func refreshView() { }

  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never>

  init(state: SimpleViewState<TVShowCellViewModel>) {
    viewStateObservableSubject = CurrentValueSubject(state)
  }
}
