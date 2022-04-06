//
//  SeasonListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import CombineSchedulers
import Shared

protocol SeasonListViewModelDelegate: AnyObject {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int)
}

protocol SeasonListViewModelProtocol {

  // MARK: - Input
  // MARK: - TODO, refactor this, change signature, choice between delegate and Streams.
  func selectSeason(_ season: Int)
  func selectSeason(seasonNumber: Int)

  // MARK: - Output
  var seasons: CurrentValueSubject<[Int], Never> { get }
  var seasonSelected: CurrentValueSubject<Int, Never> { get }
  func getModel(for season: Int) -> SeasonEpisodeViewModel

  var delegate: SeasonListViewModelDelegate? { get set }
}

final class SeasonListViewModel: SeasonListViewModelProtocol {
  private var seasonList: [Int]
  private let inputSelectedSeason = CurrentValueSubject<Int, Never>(0)

  weak var delegate: SeasonListViewModelDelegate?
  private var disposeBag = Set<AnyCancellable>()
  private let scheduler: AnySchedulerOf<DispatchQueue>

  let seasons: CurrentValueSubject<[Int], Never>
  let seasonSelected = CurrentValueSubject<Int, Never>(0)

  // MARK: Initalizer
  init(seasonList: [Int], scheduler: AnySchedulerOf<DispatchQueue> = .main) {
    self.seasonList = seasonList
    self.scheduler = scheduler
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

  // MARK: - TODO Review  method + Observable or Two methods only
  func selectSeason(_ season: Int) {
    if seasonList.contains(season) {
      seasonSelected.send(season)
    }
  }

  func selectSeason(seasonNumber: Int) {
    inputSelectedSeason.send(seasonNumber)
  }

  private func subscribe() {
    inputSelectedSeason
      .receive(on: scheduler)
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
