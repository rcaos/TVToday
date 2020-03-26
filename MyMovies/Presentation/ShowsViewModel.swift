//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

protocol ShowsViewModel: class {
  
  associatedtype TVShowCellViewModel
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase { get set }
  
  var filter: TVShowsListFilter { get set }
  
  var viewState: Observable<SimpleViewState<TVShow>> { get set }
  
  var shows: [TVShow] { get set }
  
  var cellsmodels: [TVShowCellViewModel] { get set }
  
  var showsLoadTask: Cancellable? { get set }
  
  func createModels(for fetched: [TVShow])
}

extension ShowsViewModel {
  
  func getShows(for page: Int) {
    
    if viewState.value.isInitialPage {
      viewState.value =  .loading
    }
    
    let request = FetchTVShowsUseCaseRequestValue(filter: filter, page: page)
    
    showsLoadTask = fetchTVShowsUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let results):
        strongSelf.processFetched(for: results)
      case .failure(let error):
        strongSelf.viewState.value = .error(error.localizedDescription)
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
      return
    }
    
    if response.hasMorePages {
      self.viewState.value = .paging(shows, next: response.nextPage)
    } else {
      self.viewState.value = .populated(shows)
    }
  }
}
