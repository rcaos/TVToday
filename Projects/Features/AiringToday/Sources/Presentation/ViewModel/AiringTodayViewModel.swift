//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
import Shared

final class AiringTodayViewModel: AiringTodayViewModelProtocol, ShowsViewModel {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  let viewStateObservableSubject = CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never>(.loading)

  var shows: [TVShow]
  var showsCells: [AiringTodayCollectionViewModel] = []

  weak var coordinator: AiringTodayCoordinatorProtocol?
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: AiringTodayCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []
  }

  func mapToCell(entites: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entites.map { AiringTodayCollectionViewModel(show: $0) }
  }

  // MARK: Input
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

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    return viewStateObservableSubject.value
  }

  func showIsPicked(with id: Int) {
    coordinator?.navigate(to: .showIsPicked(id))
  }
}
