//
//  SeasonsListViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/23/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

final class SeasonsListViewModel {
  
  private let fetchEpisodesUseCase: FetchEpisodesUseCase
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  private var tvShowId: Int!
  private var showDetailResult: TVShowDetailResult?
  
  private let allEpisodesSubject = BehaviorSubject<[Int:[Episode]]>(value: [:])
  
  var viewState:Observable<ViewState> = Observable(.loading)
  
  var didLoad: Observable<Bool> = Observable(false)
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  // MARK: - Output VM
  private let dataObservableSubject = BehaviorSubject<[SeasonsSectionModel]>(value: [])
  
  // what happen its exists season 0?
  private let seasonSelectedSubject = BehaviorSubject<Int>(value: 0)
  
  private var seasonListViewModel: SeasonEpisodeTableViewModel?
  
  //MARK: - Initializers
  
  init(tvShowId: Int,fetchDetailShowUseCase: FetchTVShowDetailsUseCase, fetchEpisodesUseCase: FetchEpisodesUseCase) {
    self.tvShowId = tvShowId
    
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchEpisodesUseCase = fetchEpisodesUseCase
    
    self.input = Input()
    self.output = Output(data: dataObservableSubject.asObservable())
    
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
    self.viewState.value = .populated(episodes)
    if let numberOfSeasons = showDetailResult?.numberOfSeasons {
      createSectionModel(with: numberOfSeasons, seasonSelected: number, and: episodes)
    }
  }
  
  func getShowDetails() {
    fetchShowDetails(for: tvShowId)
  }
  
  fileprivate func createSeasonsModel(with numberOfSeasons: Int?) {
    guard let numberOfSeasons = numberOfSeasons else { return }
    print("--> Creando SeasonListViewModel ...")
    let seasons: [Int] = (1...numberOfSeasons).map { $0 }
    seasonListViewModel = SeasonEpisodeTableViewModel(seasons: seasons)
  }
  
  fileprivate func selectFirstSeason() {
    let firstSeason = 1
    seasonSelectedSubject.onNext(firstSeason)
    
    // Para hacer Scroll en la CV de seasons, Why?
    // MARK: - TODO
    //      if let model = viewSeasonModel,
    //        let selectedFunction = model.selectedCell {
    //        selectedFunction(firstSeason)
    //      }
  }
  
  func getSeason(at index: Int) {
    let numberOfSeason = index + 1
    seasonSelectedSubject.onNext(numberOfSeason)
  }
  
  func buildHeaderViewModel() -> SeasonHeaderViewModel? {
    guard let show = showDetailResult else { return nil }
    return SeasonHeaderViewModel(showDetail: show)
  }
  
  //MARK: - Helper
  
  fileprivate func fetchShowDetails(for tvShowId: Int) {
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: tvShowId)
    _ = fetchDetailShowUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let response):
        strongSelf.showDetailResult = response
        strongSelf.createSeasonsModel(with: response.numberOfSeasons)
        strongSelf.didLoad.value = true
        strongSelf.selectFirstSeason()
        
        
      case .failure(let error):
        strongSelf.viewState.value = .error(error)
      }
    }
  }
  
  fileprivate func fetchEpisodesFor(season seasonNumber: Int) {
    print("Se consulta Episodes para Season: \(seasonNumber)")
    
    self.viewState.value = .loading
    // Like a new State
    if let numberOfSeasons = showDetailResult?.numberOfSeasons {
      createSectionModel(with: numberOfSeasons, seasonSelected: seasonNumber, and: [])
    }
    
    let request = FetchEpisodesUseCaseRequestValue(showIdentifier: tvShowId, seasonNumber: seasonNumber)
    
    _ = fetchEpisodesUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      
      switch result {
      case .success(let response):
        strongSelf.processFetched(with: response)
      case .failure(let error):
        print("error: [\(error)]")
        strongSelf.viewState.value = .error(error)
      }
    }
  }
  
  fileprivate func processFetched(with response: SeasonResult) {
    let fetchedEpisodes = response.episodes ?? []
    let season = response.seasonNumber
    
    print("Se recibieron: \(fetchedEpisodes.count) episodios para Season: \(season)")
    if fetchedEpisodes.isEmpty{
      self.viewState.value = .empty
    }
    
    let ordered = fetchedEpisodes.sorted(by: { $0.episodeNumber < $1.episodeNumber })
    
    allEpisodesSubject.onNext([season:ordered])
    
    self.viewState.value = .populated(ordered)
    
    // Like a new State
    if let numberOfSeasons = showDetailResult?.numberOfSeasons {
      createSectionModel(with: numberOfSeasons, seasonSelected: season, and: ordered)
    }
  }
  
  fileprivate func createSectionModel(with numberOfSeasons: Int, seasonSelected: Int, and episodes: [Episode]) {
    
    let episodesSectioned = episodes.map {
      EpisodeSectionModelType(episode: $0) }.map { SeasonsSectionItem.episodes(items: $0) }
    
    dataObservableSubject.onNext(
      [
        .seasons(header: "Seasons", items: [.seasons(number:numberOfSeasons)]),
        .episodes(header: "Episodes", items:  episodesSectioned )
    ])
  }
  
  func buildModelForSeasons(with numberOfSeasons: Int) -> SeasonEpisodeTableViewModel {
    if let viewModel = seasonListViewModel {
      print("--> Existe ya SeasonListViewModel")
      return viewModel
    } else {
      print("--> NO Existe SeasonListViewModel, crear")
      createSeasonsModel(with: numberOfSeasons)
      return seasonListViewModel!
    }
  }
  
  func getModel(for episode: EpisodeSectionModelType) -> SeasonListTableViewModel? {
    return SeasonListTableViewModel(episode: EpisodeSectionModelType.buildEpisode(from: episode) )
  }
}

extension SeasonsListViewModel {
  
  enum ViewState {
    
    case loading
    case populated([Episode])
    case empty
    case error(Error)
    
    var currentEpisodes : [Episode] {
      switch self{
      case .populated(let episodes):
        return episodes
      default:
        return []
      }
    }
  }
}

// MARK: - ViewModel Base

extension SeasonsListViewModel {
  
  public struct Input { }
  
  public struct Output {
    // MARK: - TODO, Change for State
    // MARK: - TODO, change RxSwift
    let data: RxSwift.Observable<[SeasonsSectionModel]>
  }
}
