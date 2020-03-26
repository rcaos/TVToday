//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation

enum TVShowDetailViewModelRoute {
  case initial
  case showSeasonsList(tvShowResult: TVShowDetailResult)
}

final class TVShowDetailViewModel {
  
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  var id: Int!
  var backDropPath: URL?
  var nameShow: String?
  var yearsRelease: String?
  var duration: String?
  var genre: String?
  var numberOfEpisodes: String?
  var posterPath: URL?
  var overView: String?
  var score: String?
  var countVote: String?
  
  private var showDetail: TVShowDetailResult?
  
  var viewState:Observable<ViewState> = Observable(.loading)
  
  var route: Observable<TVShowDetailViewModelRoute> = Observable(.initial)
  
  private var showsLoadTask: Cancellable? {
    willSet {
      showsLoadTask?.cancel()
    }
  }
  
  // MARK: - TODO, remove poster Repository
  init(_ idShow: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase) {
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    id = idShow
  }
  
  //MARK: - Networking
  
  func getShowDetails() {
    self.viewState.value = .loading
    
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: id)
    
    showsLoadTask = fetchDetailShowUseCase.execute(requestValue: request) { [weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let response):
        strongSelf.processFetched(for: response)
      case .failure(let error):
        print("Error to fetch Case use \(error)")
      }
    }
  }
  
  private func processFetched(for response: TVShowDetailResult) {
    self.setupTVShow(response)
    self.viewState.value = .populated
  }
  
  private func setupTVShow(_ show: TVShowDetailResult) {
    id = show.id
    backDropPath = show.getbackDropPathURL()
    posterPath = show.getposterPathURL()
    nameShow = show.name
    yearsRelease = show.releaseYears
    duration = show.episodeDuration
    genre = show.genreIds?.first?.name
    numberOfEpisodes = (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : ""
    overView = show.overview
    score = (show.voteAverage != nil) ? String(show.voteAverage!) : ""
    countVote = (show.voteCount != nil) ? String(show.voteCount!) : ""
    
    showDetail = show
  }
  
  func showSeasonList() {
    guard let showDetail = showDetail else { return }
    route.value = .showSeasonsList(tvShowResult: showDetail)
  }
}

// MARK: - ViewState

extension TVShowDetailViewModel {
  
  enum ViewState {
    
    case loading
    case populated
    case empty
    case error(Error)
  }
}
