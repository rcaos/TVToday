//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine

final class SearchViewModel {

  var resultsViewModel: ResultsSearchViewModelProtocol?

  weak var coordinator: SearchCoordinatorProtocol?

  let searchBarTextSubject: CurrentValueSubject<String, Never> = .init("")

  // MARK: - Initializer
  init() { }

  // MARK: - Public
  func startSearch(with text: String) {
    resultsViewModel?.searchShows(with: text)
  }

  func resetSearch() {
    resultsViewModel?.resetSearch()
  }

  // MARK: - Navigation
  fileprivate func navigateTo(step: SearchStep) {
    coordinator?.navigate(to: step)
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
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectShow idShow: Int) {
    navigateTo(step: .showIsPicked(withId: idShow))
  }

  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModelProtocol,
                              didSelectRecentSearch query: String) {
    searchBarTextSubject.send(query)
    startSearch(with: query)
  }
}
