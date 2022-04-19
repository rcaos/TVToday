//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
import CombineSchedulers
import Shared

final class AiringTodayViewModel: AiringTodayViewModelProtocol, ShowsViewModel {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  let viewStateObservableSubject = CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never>(.loading)

  var shows: [TVShow]
  var showsCells: [AiringTodayCollectionViewModel] = []

  let scheduler: AnySchedulerOf<DispatchQueue>
  private weak var coordinator: AiringTodayCoordinatorProtocol?
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main,
       coordinator: AiringTodayCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.scheduler = scheduler
    self.coordinator = coordinator
    shows = []
  }

  func mapToCell(entities: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entities.map { AiringTodayCollectionViewModel(show: $0) }
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
