//
//  TVShowListViewModelMock.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import RxSwift
import Shared

@testable import TVShowsList

class TVShowListViewModelMock: TVShowListViewModelProtocol {

  func viewDidLoad() { }

  func didLoadNextPage() { }

  func showIsPicked(with id: Int) { }

  func refreshView() { }

  func viewDidFinish() { }

  func getCurrentViewState() -> SimpleViewState<TVShowCellViewModel> {
    if let currentViewState = try? viewStateObservableSubject.value() {
      return currentViewState
    }
    return .empty
  }

  var viewState: Observable<SimpleViewState<TVShowCellViewModel>>

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>>

  init(state: SimpleViewState<TVShowCellViewModel>) {
    viewStateObservableSubject = BehaviorSubject(value: state)
    viewState = viewStateObservableSubject.asObservable()
  }
}
