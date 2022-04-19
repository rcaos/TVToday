//
//  SeasonListViewModelMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import ShowDetailsFeature

class SeasonListViewModelMock: SeasonListViewModelProtocol {
  var inputSelectedSeason = CurrentValueSubject<Int, Never>(0)

  func selectSeason(seasonNumber: Int) { }

  var seasons = CurrentValueSubject<[Int], Never>([])

  var seasonSelected = CurrentValueSubject<Int, Never>(0)

  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }

  weak var delegate: SeasonListViewModelDelegate?

  init(seasonList: [Int]) {
    seasons = CurrentValueSubject(seasonList)
  }

  func selectSeason(_ season: Int) {
    seasonSelected.send(season)
  }
}
