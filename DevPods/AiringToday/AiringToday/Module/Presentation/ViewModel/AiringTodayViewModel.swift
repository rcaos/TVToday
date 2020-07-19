//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

final class AiringTodayViewModel: ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var shows: [TVShow]
  
  var showsCells: [AiringTodayCollectionViewModel] = []
  
  weak var coordinator: AiringTodayCoordinatorProtocol?
  
  var disposeBag = DisposeBag()
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  var viewStateObservableSubject = BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: AiringTodayCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func mapToCell(entites: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entites.map { AiringTodayCollectionViewModel(show: $0) }
  }
  
  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    guard let currentState = try? viewStateObservableSubject.value() else { return .loading }
    return currentState
  }
  
  func showIsPicked(with id: Int) {
    navigateTo(step: .showIsPicked(id))
  }
  
  // MARK: - Navigation
  
  fileprivate func navigateTo(step: AiringTodayStep) {
    coordinator?.navigate(to: step)
  }
}

// MARK: - BaseViewModel

extension AiringTodayViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>
  }
}
