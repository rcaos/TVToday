//
//  AiringTodayViewModelProtocol.swift
//  AiringToday
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Shared
import RxSwift

protocol AiringTodayViewModelProtocol {
  // MARK: - Input
  func viewDidLoad()
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()

  // MARK: - Output
  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>> { get }
  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel>
}
