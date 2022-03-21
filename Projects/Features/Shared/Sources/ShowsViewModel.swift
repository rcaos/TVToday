//
//  ShowsViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import Combine

public protocol ShowsViewModel: AnyObject {
  associatedtype MovieCellViewModel: Equatable

  var fetchTVShowsUseCase: FetchTVShowsUseCase { get set }

  var shows: [TVShow] { get set }

  var showsCells: [MovieCellViewModel] { get set }

  var viewStateObservableSubject: BehaviorSubject<SimpleViewState<MovieCellViewModel>> { get set }

  var disposeBag: DisposeBag { get set }

  var cancellabes: Set<AnyCancellable> { get set }

  func mapToCell(entites: [TVShow]) -> [MovieCellViewModel]
}

extension ShowsViewModel {

  public func getShows(for page: Int, showLoader: Bool = true) {

    if let state = try? viewStateObservableSubject.value(),
      state.isInitialPage,
      showLoader {
      viewStateObservableSubject.onNext(.loading)
    }

    let request = FetchTVShowsUseCaseRequestValue(page: page)

    fetchTVShowsUseCase.execute(requestValue: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewStateObservableSubject.onNext(.error(error.localizedDescription))
        case .finished: break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(for: result, currentPage: page)
      })
      .store(in: &cancellabes)
  }

  private func processFetched(for response: TVShowResult, currentPage: Int) {
    if currentPage == 1 {
      shows.removeAll()
    }

    let fetchedShows = response.results ?? []

    self.shows.append(contentsOf: fetchedShows)

    if self.shows.isEmpty ||
      (fetchedShows.isEmpty && response.page == 1) {
      viewStateObservableSubject.onNext(.empty)
      return
    }

    let cellsShows = mapToCell(entites: shows)

    if response.hasMorePages {
      viewStateObservableSubject.onNext( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.onNext( .populated(cellsShows) )
    }
  }
}
