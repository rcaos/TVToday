//
//  SeasonEpisodeTableViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/24/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

final class SeasonEpisodeTableViewModel {
  
  private var seasonsList:[Int]
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  private var seasonsObservableSubject: BehaviorSubject<[Int]>
  
  private var seasonSelectedObservableSubject = BehaviorSubject<Int>(value: 0)
  
  // MARK: Initalizer
  
  init( seasons: [Int] ) {
    self.seasonsList = seasons
    
    // MARK: - TODO, input select Season should be here
    self.input = Input()
    
    self.seasonsObservableSubject = BehaviorSubject(value: seasons)
    self.output = Output(
      seasons: seasonsObservableSubject.asObservable(),
      seasonSelected: seasonSelectedObservableSubject.asObservable())
  }
  
  // MARK: - Public
  
  func getModel(for season: Int) -> SeasonEpisodeCollectionViewModel {
    return SeasonEpisodeCollectionViewModel(seasonNumber: season)
  }
  
  func selectSeason(_ season: Int) {
    if seasonsList.contains(season) {
      seasonSelectedObservableSubject.onNext(season)
    }
  }
}

// MARK: - ViewModel Base

extension SeasonEpisodeTableViewModel {
  
  // MARK: - TODO, Selected season should be here
  public struct Input {
    // ...
  }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let seasons: RxSwift.Observable<[Int]>
    let seasonSelected: RxSwift.Observable<Int>
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
