//
//  TVShowListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay
import Shared

final class TVShowListViewModel: ShowsViewModel {
  
  var steps = PublishRelay<Step>()
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var shows: [TVShow]
  
  var showsCells: [TVShowCellViewModel] = []
  
  var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<TVShowCellViewModel>> = .init(value: .loading)
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.shows = []
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func mapToCell(entites: [TVShow]) -> [TVShowCellViewModel] {
    return entites.map { TVShowCellViewModel(show: $0) }
  }

}

// MARK: - BaseViewModel

extension TVShowListViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<TVShowCellViewModel>>
  }
}

// MARK: - Stepper

extension TVShowListViewModel {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}
