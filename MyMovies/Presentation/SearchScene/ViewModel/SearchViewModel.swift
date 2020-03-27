//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift

enum SearchViewModelRoute {
  case initial
  case showMovieDetail(identifier: Int)
  case showShowList(genreId: Int)
}

final class SearchViewModel {
  
  private let fetchGenresUseCase: FetchGenresUseCase
  var route: Observable<SearchViewModelRoute> = Observable(.initial)
  
  var input: Input
  var output: Output
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<Genre>>(value: .loading)
  
  // MARK: - Initializer
  
  init(fetchGenresUseCase: FetchGenresUseCase) {
    self.fetchGenresUseCase = fetchGenresUseCase
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable())
  }
  
  func getGenres() {
    
    let _ = fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue()) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let response):
        strongSelf.processFetched(for: response)
      case .failure(let error):
        print("Error to fetch Case use \(error)")
        strongSelf.viewStateObservableSubject.onNext( .error(error.localizedDescription) )
      }
    }
  }
  
  // MARK: - Private
  
  private func processFetched(for response: GenreListResult) {
    let fetchedGenres = response.genres ?? []
    
    if fetchedGenres.isEmpty {
      viewStateObservableSubject.onNext(.empty)
      return
    }
    viewStateObservableSubject.onNext( .populated(fetchedGenres) )
  }
  
  // MARK: - Navigation
  func showTVShowDetails(with identifier: Int) {
    route.value = .showMovieDetail(identifier: identifier)
  }
  
  func showShowsList(genreId: Int) {
    route.value = .showShowList(genreId: genreId)
  }
}

// MARK: - ViewModel Base

extension SearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let viewState: RxSwift.Observable<SimpleViewState<Genre>>
  }
}
