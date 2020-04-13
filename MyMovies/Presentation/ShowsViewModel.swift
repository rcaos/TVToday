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
  
  associatedtype MovieCellViewModel
  
  var fetchTVShowsUseCase: FetchTVShowsUseCase { get set }
  
  var filter: TVShowsListFilter { get set }
  
  var shows: [TVShow] { get set }
  
  var showsCells: [MovieCellViewModel] { get set }
  
  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<MovieCellViewModel>> { get set }
  
  var disposeBag: DisposeBag { get set }
  
  func mapToCell(entites: [TVShow]) -> [MovieCellViewModel]
}

extension ShowsViewModel {
  
  func getShows(for page: Int) {
    
    if let state = try? viewStateObservableSubject.value(), state.isInitialPage {
      viewStateObservableSubject.onNext(.loading)
    }
    
    let request = FetchTVShowsUseCaseRequestValue(filter: filter, page: page)
    
    fetchTVShowsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: result)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
      })
      .disposed(by: disposeBag)
  }
  
  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []
    
    self.shows.append(contentsOf: fetchedShows)
    
    if self.shows.isEmpty ||
      (fetchedShows.isEmpty && response.page == 1) {
      viewStateObservableSubject.onNext(.empty)
      return
    }
    
    let cellsShows = mapToCell(entites: shows)
    
    // MARK: TODO, for test only, 3 pages, simulated Ended List
    if response.hasMorePages
      && response.nextPage < 4 {
      viewStateObservableSubject.onNext( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.onNext( .populated(cellsShows) )
    }
  }
}
