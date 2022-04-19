//
//  TVShowDetailViewModel+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import Combine
@testable import ShowDetailsFeature

class TVShowDetailViewModelMock: TVShowDetailViewModelProtocol {
  // MARK: - Input
  func viewDidLoad() { }
  func refreshView() { }
  func viewDidFinish() { }

  func favoriteButtonDidTapped() { }
  func watchedButtonDidTapped() { }

  // MARK: - Output
  func isUserLogged() -> Bool { return true }
  func navigateToSeasons() { }

  var viewState: CurrentValueSubject<TVShowDetailViewModel.ViewState, Never>
  var isFavorite = CurrentValueSubject<Bool, Never>(false)
  var isWatchList = CurrentValueSubject<Bool, Never>(false)

  init(state: TVShowDetailViewModel.ViewState) {
    viewState = CurrentValueSubject(state)
  }
}
