//
//  EpisodesListViewModel+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import Combine
import CombineSchedulers
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

  func getViewModelForAllSeasons() -> SeasonListViewModelProtocol? {
    return seasonListViewModel
  }

  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel? {
    return EpisodeItemViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }

  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int) { }

  var viewState: CurrentValueSubject<EpisodesListViewModel.ViewState, Never>
  var data: CurrentValueSubject<[SeasonsSectionModel], Never>

  private var seasonListViewModel: SeasonListViewModelProtocol?

  init(state: EpisodesListViewModel.ViewState,
       numberOfSeasons: Int = 1,
       seasonSelected: Int = 1,
       episodes: [Episode] = [],
       headerViewModel: SeasonHeaderViewModel? = nil) {

    // MARK: - TODO
    viewState = CurrentValueSubject(state)
    data = CurrentValueSubject([])

    seasonListViewModel = SeasonListViewModelMock(seasonList: (1...numberOfSeasons).map { $0 })
    seasonListViewModel?.selectSeason(seasonSelected)

    let dataSource = createSectionModel(headerViewModel, and: episodes)
    data.send(dataSource)
  }
}

// MARK: - Helpers
private func createSectionModel(_ headerViewModel: SeasonHeaderViewModel?,
                                and episodes: [Episode]) -> [SeasonsSectionModel] {
  var dataSourceSections = [SeasonsSectionModel]()

  if let viewModel = headerViewModel {
    dataSourceSections.append(.headerShow(items: [.headerShow(viewModel: viewModel )]))
  }

  dataSourceSections.append(.seasons(items: [.seasons]))

  let episodesSectioned = episodes
    .map { EpisodeSectionModelType(episode: $0) }
    .map { SeasonsSectionItem.episodes(items: $0) }

  dataSourceSections.append(.episodes(items: episodesSectioned))
  return dataSourceSections
}
