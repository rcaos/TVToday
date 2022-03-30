//
//  PopularViewModel+Mock.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift

@testable import PopularShows
@testable import Shared

class PopularViewModelMock: PopularViewModelProtocol {

  func viewDidLoad() { }

  func didLoadNextPage() { }

  func showIsPicked(with id: Int) { }

  func refreshView() { }

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
