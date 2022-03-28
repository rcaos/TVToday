//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
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
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> { get }
}

final class TVShowListViewModel: TVShowListViewModelProtocol, ShowsViewModel {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  let viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> = .init(.loading)

  var shows: [TVShow]
  var showsCells: [TVShowCellViewModel] = []

  private weak var coordinator: TVShowListCoordinatorProtocol?
  private let stepOrigin: TVShowListStepOrigin?

  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: TVShowListCoordinatorProtocol?,
       stepOrigin: TVShowListStepOrigin? = nil) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    self.shows = []
    self.stepOrigin = stepOrigin
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func mapToCell(entities: [TVShow]) -> [TVShowCellViewModel] {
    return entites
      .filter { $0.isActive }
      .map { TVShowCellViewModel(show: $0) }
  }

  // MARK: - Input
  func viewDidLoad() {
    getShows(for: 1)
  }

  func didLoadNextPage() {
    if case .paging(_, let nextPage) = viewStateObservableSubject.value {
      getShows(for: nextPage)
    }
  }

  func refreshView() {
    getShows(for: 1, showLoader: false)
  }

  // MARK: - Navigation
  public func showIsPicked(with id: Int) {
    let step = TVShowListStep.showIsPicked(showId: id, stepOrigin: stepOrigin, closure: updateTVShow)
    coordinator?.navigate(to: step)
  }

  public func viewDidFinish() {
    coordinator?.navigate(to: .showListDidFinish)
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
      viewStateObservableSubject.send(.empty)
      return
    }

    switch viewStateObservableSubject.value {
    case .paging(_, let nextPage):
      viewStateObservableSubject.send( .paging(cells, next: nextPage) )
    case .populated:
      viewStateObservableSubject.send(.populated(cells))
    default:
      break
    }
  }
}
