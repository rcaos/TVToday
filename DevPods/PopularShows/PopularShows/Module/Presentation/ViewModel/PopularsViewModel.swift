//
//  PopularsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

final class PopularViewModel: ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .loading)
  
  weak var coordinator: PopularCoordinatorProtocol?
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase, coordinator: PopularCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }
  
  func showIsPicked(with id: Int) {
    navigateTo(step: .showIsPicked(id) )
  }
  
  func refreshView() {
    getShows(for: 1, showLoader: false)
  }
  
  // MARK: - Navigation
  
  private func navigateTo(step: PopularStep) {
    coordinator?.navigate(to: step)
  }
}

// MARK: - BaseViewModel

extension PopularViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
  }
}
