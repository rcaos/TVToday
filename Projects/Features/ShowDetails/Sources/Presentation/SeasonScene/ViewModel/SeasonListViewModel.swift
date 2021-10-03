//
//  SeasonListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxDataSources
import Shared

protocol SeasonListViewModelDelegate: AnyObject {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int)
}

protocol SeasonListViewModelProtocol {

  // MARK: - Input
  var inputSelectedSeason: BehaviorSubject<Int> { get }
  func selectSeason(_ season: Int)

  // MARK: - Output
  var seasons: Observable<[Int]> { get }
  var seasonSelected: Observable<Int> { get }
  func getModel(for season: Int) -> SeasonEpisodeViewModel
  var disposeBag: DisposeBag { get }
  var delegate: SeasonListViewModelDelegate? { get set }
}

final class SeasonListViewModel: SeasonListViewModelProtocol {

  private var seasonList: [Int]

  private var seasonsObservableSubject: BehaviorSubject<[Int]>

  private var seasonSelectedObservableSubject = BehaviorSubject<Int>(value: 0)

  var disposeBag = DisposeBag()

  // MARK: - Public Api
  var seasons: Observable<[Int]>
  var seasonSelected: Observable<Int>
  var inputSelectedSeason: BehaviorSubject<Int>
  weak var delegate: SeasonListViewModelDelegate?

  // MARK: Initalizer
  init(seasonList: [Int] ) {
    self.seasonList = seasonList
    seasonsObservableSubject = BehaviorSubject(value: seasonList)
    seasons = seasonsObservableSubject.asObservable()

    seasonSelected = seasonSelectedObservableSubject.asObservable()

    inputSelectedSeason = BehaviorSubject(value: 0)

    subscribe()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  // MARK: - Public

  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }

  func selectSeason(_ season: Int) {
    if seasonList.contains(season) {
      seasonSelectedObservableSubject.onNext(season)
    }
  }

  fileprivate func subscribe() {
    inputSelectedSeason
      .subscribe(onNext: { [weak self] season in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.seasonListViewModel(strongSelf, didSelectSeason: season)
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - Data Source
struct SectionSeasonsList {
  var header: String
  var items: [Item]
}

extension SectionSeasonsList: SectionModelType {

  typealias Item = Int

  init(original: SectionSeasonsList, items: [Item]) {
    self = original
    self.items = items
  }
}
