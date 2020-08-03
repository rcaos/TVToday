//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

final class TVShowListViewModel: ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .loading)
  
  private weak var coordinator: TVShowListCoordinatorProtocol?
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase, coordinator: TVShowListCoordinatorProtocol) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    self.shows = []
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }
  
  func getCurrentState() -> SimpleViewState<TVShowCellViewModel> {
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

// MARK: - BaseViewModel

extension TVShowListViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
  }
}
