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
  
  var seasons:[Int]
  
  var cellModels:[SeasonEpisodeCollectionViewModel] {
    return seasons.map( {
      SeasonEpisodeCollectionViewModel(seasonNumber: $0)
    } )
  }
  
  var selectedCell: ( (Int) -> Void)?
  
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  var seasonsObservableSubject: BehaviorSubject<[Int]>
  
  
  // MARK: Initalizer
  
  init( seasons: [Int] ) {
    self.seasons = seasons
    
    // MARK: - TODO, input select Season should be here
    self.input = Input()
    
    self.seasonsObservableSubject = BehaviorSubject(value: seasons)
    self.output = Output(seasons: seasonsObservableSubject.asObservable())
  }
  
  func getSeasonNumber(for index: Int) -> Int? {
    return seasons[index]
  }
  
  func getNumberOfSeasons() -> Int {
    return seasons.count
  }
  
  func getModelFor(_ indexPath: Int) -> SeasonEpisodeCollectionViewModel {
    return cellModels[indexPath]
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
