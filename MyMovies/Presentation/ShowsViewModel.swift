//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

protocol ShowsViewModel: class {
  
  associatedtype TVShowCellViewModel
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase { get set }
  
  var filter: TVShowsListFilter { get set }
  
  // MARK: - TODO, remove viewState
  var viewState: Observable<SimpleViewState<TVShow>> { get set }
  
  var shows: [TVShow] { get set }
  
  var cellsmodels: [TVShowCellViewModel] { get set }
  
  var showsLoadTask: Cancellable? { get set }
  
  func createModels(for fetched: [TVShow])
  
  var showsObservableSubject: RxSwift.BehaviorSubject<SimpleViewState<TVShow>> { get set }
}

extension ShowsViewModel {
  
  func getShows(for page: Int) {
    
    if viewState.value.isInitialPage {
      viewState.value =  .loading
      showsObservableSubject.onNext(.loading)
    }
    
    let request = FetchTVShowsUseCaseRequestValue(filter: filter, page: page)
    
    showsLoadTask = fetchTVShowsUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let results):
        strongSelf.processFetched(for: results)
      case .failure(let error):
        strongSelf.viewState.value = .error(error.localizedDescription)
        strongSelf.showsObservableSubject.onNext(.error(error.localizedDescription))
      }
    }
  }
  
  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []
    
    self.shows.append(contentsOf: fetchedShows)
    
    self.createModels(for: fetchedShows)
    
    if self.shows.isEmpty ||
      (fetchedShows.isEmpty && response.page == 1) {
      viewState.value = .empty
      showsObservableSubject.onNext(.empty)
      return
    }
    
    if response.hasMorePages {
      self.viewState.value = .paging(shows, next: response.nextPage)
      showsObservableSubject.onNext( .paging(shows, next: response.nextPage) )
    } else {
      self.viewState.value = .populated(shows)
      showsObservableSubject.onNext( .populated(shows) )
    }
  }
}
