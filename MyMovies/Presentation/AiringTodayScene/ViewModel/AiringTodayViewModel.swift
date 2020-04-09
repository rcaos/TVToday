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
  
  var disposeBag = DisposeBag()
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  var viewStateObservableSubject = BehaviorSubject<SimpleViewState<TVShow>>(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    shows = []
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func getModelFor(_ entity: TVShow) -> AiringTodayCollectionViewModel {
    return AiringTodayCollectionViewModel(show: entity)
  }
}

// MARK: - ViewModel Base

extension AiringTodayViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShow>>
  }
}

// MARK: - Stepper, Navigation

extension AiringTodayViewModel: Stepper {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}
