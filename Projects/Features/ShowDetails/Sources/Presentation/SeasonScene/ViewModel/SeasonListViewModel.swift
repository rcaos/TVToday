//
//  SeasonListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import Shared

protocol SeasonListViewModelDelegate: AnyObject {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int)
}

protocol SeasonListViewModelProtocol {

  // MARK: - Input
  var inputSelectedSeason: CurrentValueSubject<Int, Never> { get }
  func selectSeason(_ season: Int)

  // MARK: - Output
  var seasons: CurrentValueSubject<[Int], Never> { get }
  var seasonSelected: CurrentValueSubject<Int, Never> { get }
  func getModel(for season: Int) -> SeasonEpisodeViewModel

  var delegate: SeasonListViewModelDelegate? { get set }
}

final class SeasonListViewModel: SeasonListViewModelProtocol {

  private var seasonList: [Int]
  var seasons: CurrentValueSubject<[Int], Never>
  var seasonSelected = CurrentValueSubject<Int, Never>(0)
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Public Api
  let inputSelectedSeason = CurrentValueSubject<Int, Never>(0)
  weak var delegate: SeasonListViewModelDelegate?

  // MARK: Initalizer
  init(seasonList: [Int] ) {
    self.seasonList = seasonList
    seasons = CurrentValueSubject(seasonList)
    subscribe()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  // MARK: - Public

  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }

  // Why two ???, method + Observable
  func selectSeason(_ season: Int) {
    if seasonList.contains(season) {
      seasonSelected.send(season)
    }
  }

  private func subscribe() {
    inputSelectedSeason
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] season in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.seasonListViewModel(strongSelf, didSelectSeason: season)
      })
      .store(in: &disposeBag)
  }
}

// MARK: - Data Source
enum SectionSeasonsList: Hashable {
  case season
}
