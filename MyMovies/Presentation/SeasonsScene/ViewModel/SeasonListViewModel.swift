//
//  SeasonListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources
import RxRelay
import RxFlow

final class SeasonListViewModel {
  
  private var seasonsList: [Int]
  
  private var seasonsObservableSubject: BehaviorSubject<[Int]>
  
  private var seasonSelectedObservableSubject = BehaviorSubject<Int>(value: 0)
  
  var input: Input
  
  var output: Output
  
  var steps = PublishRelay<Step>()
  
  var disposeBag = DisposeBag()
  
  // MARK: Initalizer
  
  init( seasons: [Int] ) {
    self.seasonsList = seasons
    
    self.input = Input()
    
    self.seasonsObservableSubject = BehaviorSubject(value: seasons)
    self.output = Output(
      seasons: seasonsObservableSubject.asObservable(),
      seasonSelected: seasonSelectedObservableSubject.asObservable())
  }
  
  // MARK: - Public
  
  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }
  
  func selectSeason(_ season: Int) {
    if seasonsList.contains(season) {
      seasonSelectedObservableSubject.onNext(season)
    }
  }
}

// MARK: - BaseViewModel

extension SeasonListViewModel: BaseViewModel {
  
  public struct Input {
    let selectedSeason = BehaviorSubject<Int>(value: 0)
  }
  
  public struct Output {
    let seasons: Observable<[Int]>
    let seasonSelected: Observable<Int>
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
