//
//  TVShowDetailViewModel+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import RxSwift
@testable import ShowDetails

class TVShowDetailViewModelMock: TVShowDetailViewModelProtocol {

  // MARK: - Input
  func viewDidLoad() { }
  func refreshView() { }
  func viewDidFinish() { }

  var tapFavoriteButton = PublishSubject<Void>()
  var tapWatchedButton = PublishSubject<Void>()

  // MARK: - Output

  func isUserLogged() -> Bool { return true }
  func navigateToSeasons() { }

  var viewState: Observable<TVShowDetailViewModel.ViewState>
  var isFavorite = Observable<Bool>.just(false)
  var isWatchList = Observable<Bool>.just(false)

  private var viewStateObservableSubject: BehaviorSubject<TVShowDetailViewModel.ViewState>

  init(state: TVShowDetailViewModel.ViewState) {
    viewStateObservableSubject = BehaviorSubject(value: state)
    viewState = viewStateObservableSubject.asObservable()
  }
}
