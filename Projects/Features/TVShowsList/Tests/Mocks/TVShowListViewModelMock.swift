//
//  TVShowListViewModelMock.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import Combine
import Shared

@testable import TVShowsList

class TVShowListViewModelMock: TVShowListViewModelProtocol {

  func viewDidLoad() { }

  func didLoadNextPage() { }

  func showIsPicked(with id: Int) { }

  func refreshView() { }

  func viewDidFinish() { }

  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never>

  init(state: SimpleViewState<TVShowCellViewModel>) {
    viewStateObservableSubject = CurrentValueSubject(state)
  }
}
