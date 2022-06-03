//
//  AiringTodayViewModelProtocol.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Shared
import Combine

protocol AiringTodayViewModelProtocol {
  // MARK: - Input
  func viewDidLoad()
  func showIsPicked(index: Int)
  func refreshView()
  func willDisplayRow(_ row: Int, outOf totalRows: Int)

  // MARK: - Output
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never> { get }

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel>
}
