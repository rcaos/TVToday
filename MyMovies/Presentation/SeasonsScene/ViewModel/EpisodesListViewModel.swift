//
//  EpisodesListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay

final class EpisodesListViewModel {
  
  var steps = PublishRelay<Step>()
  
  private let fetchEpisodesUseCase: FetchEpisodesUseCase
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  private var tvShowId: Int!
  private var showDetailResult: TVShowDetailResult?
  private var totalSeasons: Int {
    guard let totalSeasons = showDetailResult?.numberOfSeasons else { return 0 }
    return totalSeasons
  }
  
  private let allEpisodesSubject = BehaviorSubject<[Int:[Episode]]>(value: [:])
  
  private var disposeBag = DisposeBag()
  
  private let dataObservableSubject = BehaviorSubject<[SeasonsSectionModel]>(value: [])
  
  private let viewStateObservableSubject = BehaviorSubject<ViewState>(value: .idle)
  
  private let seasonSelectedSubject = BehaviorSubject<Int>(value: 0)
  
  private var seasonListViewModel: SeasonListViewModel?
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  //MARK: - Initializers
  
  init(tvShowId: Int,fetchDetailShowUseCase: FetchTVShowDetailsUseCase, fetchEpisodesUseCase: FetchEpisodesUseCase) {
    self.tvShowId = tvShowId
    
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchEpisodesUseCase = fetchEpisodesUseCase
    
    self.input = Input()
    self.output = Output(
      data: dataObservableSubject.asObservable(),
      viewState: viewStateObservableSubject.asObservable())
    
    controlSeasons()
  }
  
  deinit {
    print("deinit SeasonsListViewModel")
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
        
        if let episodes = allEpisodes[season] as? [Episode], episodes.count > 1 {
          print("--Return episodes Not reload")
          strongSelf.changeToSeason(number: season, episodes: episodes)
        } else {
          print("--Fetch for Season: \(season)")
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
  
  //MARK: - Networking
  
  fileprivate func fetchShowDetailsAndFirstSeason() {
    let requestDetailsShow = FetchTVShowDetailsUseCaseRequestValue(identifier: tvShowId)
    let requestFirstSeason = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: 1)
    
    Observable.zip(
      fetchDetailShowUseCase.execute(requestValue: requestDetailsShow),
      fetchEpisodesUseCase.execute(requestValue: requestFirstSeason))
      .subscribe(onNext: { [weak self] (showDetails, firstSeason) in
        guard let strongSelf = self else { return }
        strongSelf.showDetailResult = showDetails
        
        strongSelf.viewStateObservableSubject.onNext( .didLoadHeader )
        strongSelf.processFetched(with: firstSeason)
        strongSelf.selectFirstSeason()
        },onError: {[weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext( .error(error) )
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func fetchEpisodesFor(season seasonNumber: Int) {
    print("Se consulta Episodes para Season: \(seasonNumber)")
    createSectionModel(state: .loading, with: totalSeasons, seasonSelected: seasonNumber, and: [])
    
    let request = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: seasonNumber)
    
    fetchEpisodesUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(with: result)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          print("error: [\(error)]")
          strongSelf.createSectionModel(state: .error(error), with: strongSelf.totalSeasons, seasonSelected: seasonNumber, and: [])
          strongSelf.viewStateObservableSubject.onNext( .error(error) )
      })
      .disposed(by: disposeBag)
  }
  
  fileprivate func processFetched(with response: SeasonResult) {
    var fetchedEpisodes = response.episodes ?? []
    let seasonFetched = response.seasonNumber
    
    // Test for empty View
    if seasonFetched == totalSeasons {
      fetchedEpisodes.removeAll()
    }
    // Remove Test, last Season
    
    print("Se recibieron: \(fetchedEpisodes.count) episodios para Season: \(seasonFetched)")
    if fetchedEpisodes.isEmpty {
      createSectionModel(state: .empty, with: totalSeasons, seasonSelected: seasonFetched, and: [])
      return
    }
    
    let ordered = fetchedEpisodes.sorted(by: { $0.episodeNumber < $1.episodeNumber })
    allEpisodesSubject.onNext([seasonFetched:ordered])
    
    // Populated State
    createSectionModel(state: .populated, with: totalSeasons, seasonSelected: seasonFetched, and: ordered)
  }
  
  fileprivate func createSectionModel(state: ViewState, with numberOfSeasons: Int, seasonSelected: Int, and episodes: [Episode]) {
    let episodesSectioned = episodes.map {
      EpisodeSectionModelType(episode: $0) }.map { SeasonsSectionItem.episodes(items: $0) }
    
    dataObservableSubject.onNext(
      [
        .seasons(header: "Seasons", items: [.seasons(number:numberOfSeasons)]),
        .episodes(header: "Episodes", items:  episodesSectioned )
    ])
    viewStateObservableSubject.onNext( state )
  }
  
  // MARK: - Public
  
  func viewDidLoad() {
    fetchShowDetailsAndFirstSeason()
  }
  
  func getSeason(at numberOfSeason: Int) {
    seasonSelectedSubject.onNext(numberOfSeason)
  }
  
  func buildHeaderViewModel() -> SeasonHeaderViewModel? {
    guard let show = showDetailResult else { return nil }
    return SeasonHeaderViewModel(showDetail: show)
  }
  
  func buildModelForSeasons(with numberOfSeasons: Int) -> SeasonListViewModel? {
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonListViewModel(seasons: seasons)
    return seasonListViewModel
  }
  
  func getModel(for episode: EpisodeSectionModelType) -> EpisodeItemViewModel? {
    return EpisodeItemViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }
}

extension EpisodesListViewModel {
  
  enum ViewState {
    
    case idle
    case didLoadHeader
    case loading
    case populated
    case empty
    case error(Error)
  }
}

// MARK: - ViewModel Base

extension EpisodesListViewModel {
  
  public struct Input { }
  
  public struct Output {
    let data: Observable<[SeasonsSectionModel]>
    
    let viewState: Observable<ViewState>
  }
}

// MARK: - Stepper

extension EpisodesListViewModel: Stepper {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
}
