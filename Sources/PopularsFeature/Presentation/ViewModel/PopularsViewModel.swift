//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
import CombineSchedulers
import Shared

protocol PopularViewModelProtocol {
  // MARK: - Input
  func viewDidLoad()
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()

  // MARK: - Output
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> { get }
}

final class PopularViewModel: PopularViewModelProtocol, ShowsViewModel {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  var shows: [TVShow]
  var showsCells: [TVShowCellViewModel] = []
  let viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> = .init(.loading)
  weak var coordinator: PopularCoordinatorProtocol?
  var scheduler: AnySchedulerOf<DispatchQueue>
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main,
       coordinator: PopularCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.scheduler = scheduler
    self.coordinator = coordinator
    shows = []
  }

  func mapToCell(entities: [TVShow]) -> [TVShowCellViewModel] {
    return entities.map { TVShowCellViewModel(show: $0) }
  }

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

  func showIsPicked(with id: Int) {
    coordinator?.navigate(to: .showIsPicked(id))
  }
}
