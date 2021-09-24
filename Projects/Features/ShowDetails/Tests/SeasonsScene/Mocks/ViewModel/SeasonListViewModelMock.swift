//
//  SeasonListViewModelMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import ShowDetails

class SeasonListViewModelMock: SeasonListViewModelProtocol {
  var inputSelectedSeason: BehaviorSubject<Int> = BehaviorSubject(value: 0)
  
  func selectSeason(_ season: Int) { }
  
  var seasons: Observable<[Int]> = Observable.just([])
  
  var seasonSelected: Observable<Int> = Observable.just(0)
  
  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }
  
  var disposeBag = DisposeBag()
  
  weak var delegate: SeasonListViewModelDelegate?
}
