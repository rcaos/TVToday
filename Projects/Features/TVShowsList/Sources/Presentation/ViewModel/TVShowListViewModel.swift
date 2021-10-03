//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared
import ShowDetailsInterface
import TVShowsListInterface

protocol TVShowListViewModelProtocol {
  // MARK: - Input
  func viewDidLoad()
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()
  func viewDidFinish()

  // MARK: - Output
  var viewState: Observable<SimpleViewState<TVShowCellViewModel>> { get }
  func getCurrentViewState() -> SimpleViewState<TVShowCellViewModel>
}

final class TVShowListViewModel: TVShowListViewModelProtocol, ShowsViewModel {
  var fetchTVShowsUseCase: FetchTVShowsUseCase

  var shows: [TVShow]

  var showsCells: [TVShowCellViewModel] = []

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .loading)

  var viewState: Observable<SimpleViewState<TVShowCellViewModel>>

  private weak var coordinator: TVShowListCoordinatorProtocol?

  var disposeBag = DisposeBag()

  let stepOrigin: TVShowListStepOrigin?

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: TVShowListCoordinatorProtocol?,
       stepOrigin: TVShowListStepOrigin? = nil) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    self.shows = []
    self.stepOrigin = stepOrigin
    viewState = viewStateObservableSubject.asObservable()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites
      .filter { $0.isActive }
      .map { TVShowCellViewModel(show: $0) }
  }

  // MARK: - Input
  func viewDidLoad() {
    getShows(for: 1)
  }

  func didLoadNextPage() {
    if case .paging(_, let nextPage) = getCurrentViewState() {
      getShows(for: nextPage)
    }
  }

  func getCurrentViewState() -> SimpleViewState<TVShowCellViewModel> {
    if let state = try? viewStateObservableSubject.value() {
      return state
    }
    return .loading
  }

  func refreshView() {
    getShows(for: 1, showLoader: false)
  }

  // MARK: - Navigation
  public func showIsPicked(with id: Int) {
    let step = TVShowListStep.showIsPicked(showId: id, stepOrigin: stepOrigin, closure: updateTVShow)
    navigateTo(step: step)
  }

  public func viewDidFinish() {
    navigateTo(step: .showListDidFinish)
  }

  private func navigateTo(step: TVShowListStep) {
    coordinator?.navigate(to: step)
  }

  // MARK: - Updated List from Show Details (Deleted Favorite, Delete WatchList)
  private func updateTVShow(_ updated: TVShowUpdated) {
    for index in shows.indices where shows[index].id == updated.showId {
      shows[index].isActive = updated.isActive
    }
    refreshCells()
  }

  private func refreshCells() {
    let cells = mapToCell(entites: shows)

    if cells.isEmpty {
      viewStateObservableSubject.onNext(.empty)
      return
    }

    guard let lastViewState = try? viewStateObservableSubject.value() else {
      return
    }

    switch lastViewState {
    case .paging(_, let nextPage):
      viewStateObservableSubject.onNext( .paging(cells, next: nextPage) )
    case .populated:
      viewStateObservableSubject.onNext(.populated(cells))
    default:
      break
    }
  }
}
