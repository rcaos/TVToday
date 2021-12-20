//
//  AiringTodayViewModelMock.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import Shared
import RxSwift
@testable import AiringToday

class AiringTodayViewModelMock: AiringTodayViewModelProtocol {

  func viewDidLoad() { }

  func didLoadNextPage() { }

  func showIsPicked(with id: Int) { }

  func refreshView() { }

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    if let currentViewState = try? viewStateObservableSubject.value() {
      return currentViewState
    }
    return .empty
  }

  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>

  init(state: SimpleViewState<AiringTodayCollectionViewModel>) {
    viewStateObservableSubject = BehaviorSubject(value: state)
    viewState = viewStateObservableSubject.asObservable()
  }
}
