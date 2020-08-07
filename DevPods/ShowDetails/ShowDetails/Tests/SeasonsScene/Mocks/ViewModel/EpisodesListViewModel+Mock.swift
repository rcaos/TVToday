//
//  EpisodesListViewModel+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import RxSwift
@testable import ShowDetails

class SeasonHeaderViewModelMock: SeasonHeaderViewModelProtocol {
  var showName: String
  
  init(showName: String) {
    self.showName = showName
  }
}

class EpisodesListViewModelMock: EpisodesListViewModelProtocol {
  
  func viewDidLoad() { }
  
  func refreshView() { }
  
  func buildHeaderViewModel() -> SeasonHeaderViewModelProtocol? {
    return headerViewModel
  }
  
  func buildModelForSeasons(with numberOfSeasons: Int) -> SeasonListViewModelProtocol? {
    return seasonListViewModel
  }
  
  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel? {
    return EpisodeItemViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }
  
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int) { }
  
  var viewState: Observable<EpisodesListViewModel.ViewState>
  
  var data: Observable<[SeasonsSectionModel]>
  
  private var dataSubject: BehaviorSubject<[SeasonsSectionModel]>
  
  private var viewStateObservableSubject: BehaviorSubject<EpisodesListViewModel.ViewState>
  
  private let headerViewModel: SeasonHeaderViewModelProtocol?
  
  private var seasonListViewModel: SeasonListViewModel?
  
  init(state: EpisodesListViewModel.ViewState,
       numberOfSeasons: Int = 1,
       seasonSelected: Int = 1,
       episodes: [Episode] = [],
       headerViewModel: SeasonHeaderViewModelProtocol? = nil) {
    
    viewStateObservableSubject = BehaviorSubject(value: .loading)
    viewState = viewStateObservableSubject.asObservable()
    
    dataSubject = BehaviorSubject(value: [])
    data = dataSubject.asObservable()
    
    self.headerViewModel = headerViewModel
    
    buildSeasonViewModel(for: numberOfSeasons)
    seasonListViewModel?.selectSeason(seasonSelected)
    
    createSectionModel(with: numberOfSeasons, and: episodes)
    
    viewStateObservableSubject.onNext(.populated)
    viewStateObservableSubject.onNext(state)
  }
  
  fileprivate func createSectionModel(with numberOfSeasons: Int,
                                      and episodes: [Episode]) {
    let episodesSectioned = episodes.map {
      EpisodeSectionModelType(episode: $0) }.map { SeasonsSectionItem.episodes(items: $0) }
    
    dataSubject.onNext([
      .seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]),
      .episodes(header: "Episodes", items: episodesSectioned )
    ])
  }
  
  fileprivate func buildSeasonViewModel(for numberOfSeasons: Int) {
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonListViewModel(seasonList: seasons)
  }
}
