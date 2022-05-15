//
//  AiringTodayViewModelMock.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import Shared
import Combine
@testable import AiringTodayFeature

class AiringTodayViewModelMock: AiringTodayViewModelProtocol {

  func viewDidLoad() { }

  func didLoadNextPage() { }

  func showIsPicked(index id: Int) { }

  func refreshView() { }

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    return viewStateObservableSubject.value
  }

  let viewStateObservableSubject: CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never>

  init(state: SimpleViewState<AiringTodayCollectionViewModel>) {
    viewStateObservableSubject = CurrentValueSubject(state)
  }
}
