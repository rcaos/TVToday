//
//  EpisodesListViewModel+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import RxSwift
@testable import ShowDetails

extension SeasonHeaderViewModel {

  static var mock: (String, String, String) -> SeasonHeaderViewModel = { name, firstAirDate, lastAirDate in
    return .init(showDetail:
                    .stub(
                      name: name,
                      firstAirDate: firstAirDate,
                      lastAirDate: lastAirDate
                    )
    )
  }
}

class EpisodesListViewModelMock: EpisodesListViewModelProtocol {

  func viewDidLoad() { }

  func refreshView() { }

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

  private var seasonListViewModel: SeasonListViewModel?

  init(state: EpisodesListViewModel.ViewState,
       numberOfSeasons: Int = 1,
       seasonSelected: Int = 1,
       episodes: [Episode] = [],
       headerViewModel: SeasonHeaderViewModel? = nil) {

    viewStateObservableSubject = BehaviorSubject(value: .loading)
    viewState = viewStateObservableSubject.asObservable()

    dataSubject = BehaviorSubject(value: [])
    data = dataSubject.asObservable()

    buildSeasonViewModel(for: numberOfSeasons)
    seasonListViewModel?.selectSeason(seasonSelected)

    createSectionModel(headerViewModel, with: numberOfSeasons, and: episodes)

    viewStateObservableSubject.onNext(.populated)
    viewStateObservableSubject.onNext(state)
  }

  fileprivate func createSectionModel(_ headerViewModel: SeasonHeaderViewModel?,
                                      with numberOfSeasons: Int,
                                      and episodes: [Episode]) {
    var dataSourceSections: [SeasonsSectionModel] = []

    if let viewModel = headerViewModel {
      dataSourceSections.append(.headerShow(header: "Header", items: [.headerShow(viewModel: viewModel )]))
    }

    dataSourceSections.append(.seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]))

    let episodesSectioned = episodes.map {
      EpisodeSectionModelType(episode: $0) }.map { SeasonsSectionItem.episodes(items: $0) }

    dataSourceSections.append(.episodes(header: "Episodes", items: episodesSectioned))

    dataSubject.onNext(dataSourceSections)
  }

  fileprivate func buildSeasonViewModel(for numberOfSeasons: Int) {
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonListViewModel(seasonList: seasons)
  }
}
