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
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()

  // MARK: - Output
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never> { get }

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel>
}
