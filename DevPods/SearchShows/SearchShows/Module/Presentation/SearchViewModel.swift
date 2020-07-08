//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay
import RxDataSources

final class SearchViewModel: Stepper {
  
  private var resultsViewModel: ResultsSearchViewModel
  
  var steps = PublishRelay<Step>()
  
  private var searchBarTextSubject: BehaviorSubject<String> = .init(value: "")
  
  var input: Input
  
  var output: Output
  
  // MARK: - Initializer
  
  init(resultsViewModel: ResultsSearchViewModel) {
    self.resultsViewModel = resultsViewModel
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
}

extension SearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    let searchBarText: Observable<String>
  }
}

// MARK: - Stepper

extension SearchViewModel: SearchOptionsViewModelDelegate {
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel, didGenrePicked idGenre: Int) {
    steps.accept(SearchStep.genreIsPicked(withId: idGenre))
  }
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel, didRecentShowPicked idShow: Int) {
    steps.accept(SearchStep.showIsPicked(withId: idShow))
  }
}

extension SearchViewModel: ResultsSearchViewModelDelegate {
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel, didSelectShow idShow: Int) {
    steps.accept(SearchStep.showIsPicked(withId: idShow))
  }
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel, didSelectRecentSearch query: String) {
    searchBarTextSubject.onNext(query)
    startSearch(with: query)
  }
}
