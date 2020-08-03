//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

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
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase, coordinator: TVShowListCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    self.shows = []
    viewState = viewStateObservableSubject.asObservable()
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
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
    navigateTo(step: .showIsPicked(showId: id))
  }
  
  public func viewDidFinish() {
    navigateTo(step: .showListDidFinish)
  }
  
  private func navigateTo(step: TVShowListStep) {
    coordinator?.navigate(to: step)
  }
}
