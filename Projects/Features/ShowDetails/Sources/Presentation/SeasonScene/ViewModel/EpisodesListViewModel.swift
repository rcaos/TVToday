//
//  EpisodesListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import Shared

protocol EpisodesListViewModelProtocol: SeasonListViewModelDelegate {
  // MARK: - Input
  func viewDidLoad()
  func refreshView()

  // MARK: - Output
  func getViewModelForAllSeasons() -> SeasonListViewModelProtocol?
  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel?

  var viewState: CurrentValueSubject<EpisodesListViewModel.ViewState, Never> { get }
  var data: CurrentValueSubject<[SeasonsSectionModel], Never> { get }
}

final class EpisodesListViewModel: EpisodesListViewModelProtocol {

  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  private let fetchEpisodesUseCase: FetchEpisodesUseCase

  private let tvShowId: Int
  private var showDetailResult: TVShowDetailResult?
  private var totalSeasons: Int {
    guard let totalSeasons = showDetailResult?.numberOfSeasons else { return 0 }
    return totalSeasons
  }

  private var allEpisodes = [Int: [Episode]]()
  private let seasonSelectedSubject = CurrentValueSubject<Int, Never>(0)

  private var seasonListViewModel: SeasonListViewModelProtocol?
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Public Api
  var viewState = CurrentValueSubject<ViewState, Never>(.loading)
  var data = CurrentValueSubject<[SeasonsSectionModel], Never>([])

  // MARK: - Initializers
  init(tvShowId: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase, fetchEpisodesUseCase: FetchEpisodesUseCase) {
    self.tvShowId = tvShowId
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchEpisodesUseCase = fetchEpisodesUseCase
    controlSeasons()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  private func controlSeasons() {
    seasonSelectedSubject
      .removeDuplicates()
      .filter { $0 >= 1 }
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] season in
        guard let strongSelf = self else { return }
        if let episodes = strongSelf.allEpisodes[season], episodes.count >= 1 {
          strongSelf.changeToSeason(number: season, episodes: episodes)
        } else {
          strongSelf.fetchEpisodesFor(season: season)
        }
      })
      .store(in: &disposeBag)
  }

  private func changeToSeason(number: Int, episodes: [Episode]) {
    createSectionModel(state: .populated, with: totalSeasons, seasonSelected: number, and: episodes)
  }

  private func selectFirstSeason() {
    let firstSeason = 1
    seasonSelectedSubject.send(firstSeason)
    seasonListViewModel?.selectSeason(firstSeason)
  }

  // MARK: - Networking
  private func fetchShowDetailsAndFirstSeason(showLoader: Bool = true) {
    if showLoader {
      viewState.send( .loading )
    }

    let requestDetailsShow = FetchTVShowDetailsUseCaseRequestValue(identifier: tvShowId)
    let requestFirstSeason = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: 1)

    Publishers.Zip(
      fetchDetailShowUseCase.execute(requestValue: requestDetailsShow),
      fetchEpisodesUseCase.execute(requestValue: requestFirstSeason)
    )
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewState.send( .error(error.localizedDescription) )
        case .finished:
          break
        }
      }, receiveValue: { [weak self] (resultShowDetails, firstSeason) in
        self?.processResultFirstFetched(resultShowDetails, firstSeason)
      })
      .store(in: &disposeBag)
  }

  private func processResultFirstFetched(_ detailsShow: TVShowDetailResult, _ firstSeason: SeasonResult) {
    showDetailResult = detailsShow
    processFetched(with: firstSeason)
    createViewModelForSeasons(numberOfSeasons: detailsShow.numberOfSeasons ?? 1)
    selectFirstSeason()
  }

  private func fetchEpisodesFor(season seasonNumber: Int) {
    createSectionModel(state: .loadingSeason, with: totalSeasons, seasonSelected: seasonNumber, and: [])

    let request = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: seasonNumber)

    fetchEpisodesUseCase.execute(requestValue: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        guard let strongSelf = self else { return }

        switch completion {
        case let .failure(error):
          strongSelf.createSectionModel(state: .errorSeason(error.localizedDescription),
                                        with: strongSelf.totalSeasons,
                                        seasonSelected: seasonNumber, and: [])
        case .finished:
          break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(with: result)
      })
      .store(in: &disposeBag)
  }

  private func processFetched(with response: SeasonResult) {
    let fetchedEpisodes = response.episodes ?? []
    let seasonFetched = response.seasonNumber

    if fetchedEpisodes.isEmpty {
      createSectionModel(state: .empty, with: totalSeasons, seasonSelected: seasonFetched, and: [])
      return
    }

    let ordered = fetchedEpisodes.sorted(by: { $0.episodeNumber < $1.episodeNumber })
    allEpisodes[seasonFetched] = ordered

    createSectionModel(state: .populated, with: totalSeasons, seasonSelected: seasonFetched, and: ordered)
  }

  private func createSectionModel(state: ViewState, with numberOfSeasons: Int, seasonSelected: Int, and episodes: [Episode]) {
    var dataSourceSections: [SeasonsSectionModel] = []

    if let headerSection = createModelForheader() {
      dataSourceSections.append(headerSection)
    }

    dataSourceSections.append(.seasons(items: [.seasons]) )

    let episodesSectioned = episodes.map { EpisodeSectionModelType(episode: $0) }
      .map { SeasonsSectionItem.episodes(items: $0) }

    dataSourceSections.append(.episodes(items: episodesSectioned) )

    data.send( dataSourceSections )
    viewState.send( state )
  }

  private func createModelForheader() -> SeasonsSectionModel? {
    if let detailShow = showDetailResult {
      return .headerShow(items: [.headerShow(viewModel: SeasonHeaderViewModel(showDetail: detailShow))])
    }
    return nil
  }

  // MARK: - Public Api
  func viewDidLoad() {
    fetchShowDetailsAndFirstSeason()
  }

  func refreshView() {
    fetchShowDetailsAndFirstSeason(showLoader: false)
  }

  private func createViewModelForSeasons(numberOfSeasons: Int) {
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonListViewModel(seasonList: seasons)
    seasonListViewModel?.delegate = self
  }

  func getViewModelForAllSeasons() -> SeasonListViewModelProtocol? {
    return seasonListViewModel
  }

  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel? {
    return EpisodeItemViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }
}

// MARK: - SeasonListViewModelDelegate
extension EpisodesListViewModel {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int) {
    seasonSelectedSubject.send(number)
  }
}

extension EpisodesListViewModel {
  enum ViewState: Equatable {
    case loading
    case populated
    case error(String)
    case loadingSeason
    case empty
    case errorSeason(String)

    static public func == (lhs: ViewState, rhs: ViewState) -> Bool {
      switch (lhs, rhs) {
      case (.loading, .loading):
        return true
      case (.populated, .populated):
        return true
      case (.error, .error):
        return true
      case (.loadingSeason, .loadingSeason):
        return true
      case (.empty, .empty):
        return true
      case (.errorSeason, .errorSeason):
        return true
      default:
        return false
      }
    }
  }
}
