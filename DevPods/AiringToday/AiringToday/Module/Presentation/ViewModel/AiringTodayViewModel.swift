//
//  AiringTodayViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/14/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

protocol AiringTodayViewModelProtocol {
  
  // MARK: - Input
  
  func viewDidLoad()
  func didLoadNextPage()
  func showIsPicked(with id: Int)
  func refreshView()
  
  // MARK: - Output
  
  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>> { get }
  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel>
}

final class AiringTodayViewModel: AiringTodayViewModelProtocol, ShowsViewModel {
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase
  
  var shows: [TVShow]
  
  var showsCells: [AiringTodayCollectionViewModel] = []
  
  weak var coordinator: AiringTodayCoordinatorProtocol?
  
  var viewState: Observable<SimpleViewState<AiringTodayCollectionViewModel>>
  
  var viewStateObservableSubject = BehaviorSubject<SimpleViewState<AiringTodayCollectionViewModel>>(value: .loading)
  
  var disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       coordinator: AiringTodayCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []
    
    viewState = viewStateObservableSubject.asObservable()
  }
  
  func mapToCell(entites: [TVShow]) -> [AiringTodayCollectionViewModel] {
    return entites.map { AiringTodayCollectionViewModel(show: $0) }
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
