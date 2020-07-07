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
  
  var resultsViewModel: ResultsSearchViewModel
  
  var steps = PublishRelay<Step>()
  
  // MARK: - Initializer
  
  init(resultsViewModel: ResultsSearchViewModel) {
    self.resultsViewModel = resultsViewModel
  }
  
  // MARK: - Public
  
  func startSearch(with text: String) {
    guard !text.isEmpty else { return }
    resultsViewModel.clearShows()
    resultsViewModel.searchShows(with: text)
  }
  
  func resetSearch() {
    resultsViewModel.resetSearch()
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
}
