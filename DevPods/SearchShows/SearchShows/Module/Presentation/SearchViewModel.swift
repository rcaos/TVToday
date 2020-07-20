//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

final class SearchViewModel {
  
  private var resultsViewModel: ResultsSearchViewModel
  
  private var searchBarTextSubject: BehaviorSubject<String> = .init(value: "")
  
  private weak var coordinator: SearchCoordinatorProtocol?
  
  var input: Input
  
  var output: Output
  
  // MARK: - Initializer
  
  init(resultsViewModel: ResultsSearchViewModel, coordinator: SearchCoordinatorProtocol?) {
    self.resultsViewModel = resultsViewModel
    self.coordinator = coordinator
    self.input = Input()
    self.output = Output(searchBarText: searchBarTextSubject.asObservable())
  }
  
  // MARK: - Public
  
  func startSearch(with text: String) {
    resultsViewModel.searchShows(with: text)
  }
  
  func resetSearch() {
    resultsViewModel.resetSearch()
  }
  
  // MARK: - Navigation
  
  fileprivate func navigateTo(step: SearchStep) {
    coordinator?.navigate(to: step)
  }
}

extension SearchViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let searchBarText: Observable<String>
  }
}

// MARK: - Stepper

extension SearchViewModel: SearchOptionsViewModelDelegate {
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didGenrePicked idGenre: Int,
                              title: String?) {
    navigateTo(step: .genreIsPicked(withId: idGenre, title: title))
  }
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel,
                              didRecentShowPicked idShow: Int) {
    navigateTo(step: .showIsPicked(withId: idShow))
  }
}

extension SearchViewModel: ResultsSearchViewModelDelegate {
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel,
                              didSelectShow idShow: Int) {
    navigateTo(step: .showIsPicked(withId: idShow))
  }
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel,
                              didSelectRecentSearch query: String) {
    searchBarTextSubject.onNext(query)
    startSearch(with: query)
  }
}
