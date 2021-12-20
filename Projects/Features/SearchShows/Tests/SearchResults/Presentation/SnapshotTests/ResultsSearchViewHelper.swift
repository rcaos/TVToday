//
//  ResultsSearchViewHelper.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

@testable import SearchShows
@testable import Shared

public func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) -> [ResultSearchSectionModel] {
  var dataSource: [ResultSearchSectionModel] = []

  let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }

  let resultsShowsItem = resultShows
    .map { TVShowCellViewModel(show: $0) }
    .map { ResultSearchSectionItem.results(items: $0) }

  if !recentSearchsItem.isEmpty {
    dataSource.append(.recentSearchs(items: recentSearchsItem))
  }

  if !resultsShowsItem.isEmpty {
    dataSource.append(.results(items: resultsShowsItem))
  }

  return dataSource
}
