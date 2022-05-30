//
//  TVShowListViewModelMock.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import Combine
import Shared
import UI

@testable import ShowListFeature

class TVShowListViewModelMock: TVShowListViewModelProtocol {

  func viewDidLoad() { }

  func willDisplayRow(_ row: Int, outOf totalRows: Int) { }

  func showIsPicked(index: Int) { }

  func refreshView() { }

  func viewDidFinish() { }

  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never>

  init(state: SimpleViewState<TVShowCellViewModel>) {
    viewStateObservableSubject = CurrentValueSubject(state)
  }
}
