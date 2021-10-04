//
//  EpisodesListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

protocol EpisodesListViewModelProtocol: SeasonListViewModelDelegate {
  // MARK: - Input
  func viewDidLoad()
  func refreshView()

  // MARK: - Output
  func buildModelForSeasons(with numberOfSeasons: Int) -> SeasonListViewModelProtocol?
  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel?

  var viewState: Observable<EpisodesListViewModel.ViewState> { get }
  var data: Observable<[SeasonsSectionModel]> { get }
}

final class EpisodesListViewModel: EpisodesListViewModelProtocol {

  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  private let fetchEpisodesUseCase: FetchEpisodesUseCase

  private var tvShowId: Int!
  private var showDetailResult: TVShowDetailResult?
  private var totalSeasons: Int {
    guard let totalSeasons = showDetailResult?.numberOfSeasons else { return 0 }
    return totalSeasons
  }

  private let allEpisodesSubject = BehaviorSubject<[Int: [Episode]]>(value: [:])

  private var disposeBag = DisposeBag()

  private let dataObservableSubject = BehaviorSubject<[SeasonsSectionModel]>(value: [])

  private let viewStateObservableSubject = BehaviorSubject<ViewState>(value: .loading)

  private let seasonSelectedSubject = BehaviorSubject<Int>(value: 0)

  private var seasonListViewModel: SeasonListViewModelProtocol?

  // MARK: - Public Api
  var viewState: Observable<ViewState>

  var data: Observable<[SeasonsSectionModel]>

  // MARK: - Initializers
  init(tvShowId: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase, fetchEpisodesUseCase: FetchEpisodesUseCase) {
    self.tvShowId = tvShowId

    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchEpisodesUseCase = fetchEpisodesUseCase

    data = dataObservableSubject.asObservable()
    viewState = viewStateObservableSubject.asObservable()

    controlSeasons()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  fileprivate func controlSeasons() {
    let episodesObservable = allEpisodesSubject
      .scan([:], accumulator: { (oldValue, newValue) in
        var currentEpisodes = oldValue
        if let season = newValue.keys.first,
          let episodes = newValue.values.first {
          currentEpisodes[season] = episodes
        }
        return currentEpisodes
      })

    seasonSelectedSubject
      .distinctUntilChanged()
      .filter { $0 >= 1 }
      .withLatestFrom(episodesObservable) { (season: $0, allEpisodes: $1) }
      .subscribe(onNext: { [weak self] (season, allEpisodes) in
        guard let strongSelf = self else { return }

        if let episodes = allEpisodes[season] as? [Episode], episodes.count >= 1 {
          strongSelf.changeToSeason(number: season, episodes: episodes)
        } else {
          strongSelf.fetchEpisodesFor(season: season)
        }

      })
      .disposed(by: disposeBag)
  }

  fileprivate func changeToSeason(number: Int, episodes: [Episode]) {
    createSectionModel(state: .populated, with: totalSeasons, seasonSelected: number, and: episodes)
  }

  fileprivate func selectFirstSeason() {
    let firstSeason = 1
    seasonSelectedSubject.onNext(firstSeason)
    seasonListViewModel?.selectSeason(firstSeason)
  }

  // MARK: - Networking
  fileprivate func fetchShowDetailsAndFirstSeason(showLoader: Bool = true) {
    if showLoader {
      viewStateObservableSubject.onNext( .loading )
    }

    let requestDetailsShow = FetchTVShowDetailsUseCaseRequestValue(identifier: tvShowId)
    let requestFirstSeason = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: 1)

    Observable.zip(
      fetchDetailShowUseCase.execute(requestValue: requestDetailsShow),
      fetchEpisodesUseCase.execute(requestValue: requestFirstSeason))
      .subscribe(onNext: { [weak self] (resultShowDetails, firstSeason) in
        guard let strongSelf = self else { return }

        // MARK: - TODO, refactor this
        switch resultShowDetails {
        case .success(let detailResult):
          strongSelf.showDetailResult = detailResult
          strongSelf.processFetched(with: firstSeason)
          strongSelf.selectFirstSeason()
        case .failure:
          strongSelf.viewStateObservableSubject.onNext( .error(CustomError.genericError.localizedDescription) )
        }
        }, onError: {[weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext( .error(CustomError.genericError.localizedDescription) )
      })
      .disposed(by: disposeBag)
  }

  fileprivate func fetchEpisodesFor(season seasonNumber: Int) {
    createSectionModel(state: .loadingSeason, with: totalSeasons, seasonSelected: seasonNumber, and: [])

    let request = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: seasonNumber)

    fetchEpisodesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(with: result)

        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.createSectionModel(state: .errorSeason(error.localizedDescription),
                                        with: strongSelf.totalSeasons,
                                        seasonSelected: seasonNumber, and: [])
      })
      .disposed(by: disposeBag)
  }

  fileprivate func processFetched(with response: SeasonResult) {
    let fetchedEpisodes = response.episodes ?? []
    let seasonFetched = response.seasonNumber

    if fetchedEpisodes.isEmpty {
      createSectionModel(state: .empty, with: totalSeasons, seasonSelected: seasonFetched, and: [])
      return
    }

    let ordered = fetchedEpisodes.sorted(by: { $0.episodeNumber < $1.episodeNumber })
    allEpisodesSubject.onNext([seasonFetched: ordered])

    createSectionModel(state: .populated, with: totalSeasons, seasonSelected: seasonFetched, and: ordered)
  }

  fileprivate func createSectionModel(state: ViewState, with numberOfSeasons: Int, seasonSelected: Int, and episodes: [Episode]) {
    var dataSourceSections: [SeasonsSectionModel] = []

    if let headerSection = createModelForheader() {
      dataSourceSections.append(headerSection)
    }

    dataSourceSections.append(.seasons(header: "Seasons", items: [.seasons(number: numberOfSeasons)]) )

    let episodesSectioned = episodes.map { EpisodeSectionModelType(episode: $0) }
      .map { SeasonsSectionItem.episodes(items: $0) }

    dataSourceSections.append(.episodes(header: "Episodes", items: episodesSectioned) )

    dataObservableSubject.onNext( dataSourceSections )
    viewStateObservableSubject.onNext( state )
  }

  fileprivate func createModelForheader() -> SeasonsSectionModel? {
    if let detailShow = showDetailResult {
      return .headerShow(header: "Header", items: [.headerShow(viewModel: SeasonHeaderViewModel(showDetail: detailShow))])
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

  func buildModelForSeasons(with numberOfSeasons: Int) -> SeasonListViewModelProtocol? {
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonListViewModel(seasonList: seasons)
    seasonListViewModel?.delegate = self
    return seasonListViewModel
  }

  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel? {
    return EpisodeItemViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }
}

// MARK: - SeasonListViewModelDelegate
extension EpisodesListViewModel {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int) {
    seasonSelectedSubject.onNext(number)
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
  }
}
