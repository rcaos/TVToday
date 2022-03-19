//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

protocol PopularViewModelProtocol {

  // MARK: - Input
  func viewDidLoad()
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()

  // MARK: - Output
  var viewState: Observable<SimpleViewState<TVShowCellViewModel>> { get }
  func getCurrentViewState() -> SimpleViewState<TVShowCellViewModel>
}

final class PopularViewModel: PopularViewModelProtocol, ShowsViewModel {

  var fetchTVShowsUseCase: FetchTVShowsUseCase

  var shows: [TVShow]

  var showsCells: [TVShowCellViewModel] = []

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .loading)

  let viewState: Observable<SimpleViewState<TVShowCellViewModel>>

  weak var coordinator: PopularCoordinatorProtocol?

  var disposeBag = DisposeBag()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: PopularCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []

    viewState = viewStateObservableSubject.asObservable()
  }

  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }

  // MARK: Input
  func viewDidLoad() {
    getShows(for: 1)
  }

  func didLoadNextPage() {
    if case .paging(_, let nextPage) = getCurrentViewState() {
      getShows(for: nextPage)
    }
  }

  func refreshView() {
    getShows(for: 1, showLoader: false)
  }

  // MARK: - Output
  func getCurrentViewState() -> SimpleViewState<TVShowCellViewModel> {
    guard let currentState = try? viewStateObservableSubject.value() else { return .loading }
    return currentState
  }

  func showIsPicked(with id: Int) {
    navigateTo(step: .showIsPicked(id) )
  }

  // MARK: - Navigation
  private func navigateTo(step: PopularStep) {
    coordinator?.navigate(to: step)
  }
}
