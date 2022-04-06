//
//  SeasonListViewModelMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import ShowDetails

class SeasonListViewModelMock: SeasonListViewModelProtocol {
  var inputSelectedSeason = CurrentValueSubject<Int, Never>(0)

  func selectSeason(_ season: Int) { }

  func selectSeason(seasonNumber: Int) { }

  var seasons = CurrentValueSubject<[Int], Never>([])

  var seasonSelected = CurrentValueSubject<Int, Never>(0)

  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }

  weak var delegate: SeasonListViewModelDelegate?
}
