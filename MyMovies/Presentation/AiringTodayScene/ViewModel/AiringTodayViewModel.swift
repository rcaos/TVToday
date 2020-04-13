//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay

final class AiringTodayViewModel: ShowsViewModel {
  
  var steps = PublishRelay<Step>()
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var filter: TVShowsListFilter = .today
  
  var shows: [TVShow]
  
  var showsCells: [AiringTodayCollectionViewModel] = []
  
  var disposeBag = DisposeBag()
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  var viewStateObservableSubject = BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func mapToCell(entites: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entites.map { AiringTodayCollectionViewModel(show: $0) }
  }
  
}

// MARK: - BaseViewModel

extension AiringTodayViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>
  }
}

// MARK: - Stepper, Navigation

extension AiringTodayViewModel {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}
