//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

// MARK: - TODO Implement Input Button Favorite movie ❤️

import RxSwift
import RxFlow
import RxRelay

final class TVShowDetailViewModel {
  
  var steps = PublishRelay<Step>()
  
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  private let showId: Int
  
  private var viewStateObservableSubject = BehaviorSubject<ViewState>(value: .loading)
  
  // MARK: - Base ViewModel
  var input: Input
  var output: Output
  
  let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init(_ showId: Int, fetchDetailShowUseCase: FetchTVShowDetailsUseCase) {
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.showId = showId
    
    self.input = Input()
    self.output = Output(
      viewState: viewStateObservableSubject.asObservable())
  }
  
  //MARK: - Networking
  
  func getShowDetails() {
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: showId)
    
    fetchDetailShowUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] response in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: response)
        },onError: { [weak self] error in
          print("-- fetchDetailShowUseCase - onError")
          guard let strongSelf = self else { return }
          
          strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
        }
        ,onCompleted: {
          print("-- fetchDetailShowUseCase - onCompleted")
      },onDisposed: {
        print("-- fetchDetailShowUseCase - onDisposed")
      })
      .disposed(by: disposeBag)
  }
  
  private func processFetched(for response: TVShowDetailResult) {
    let showDetail = setupTVShow(response)
    viewStateObservableSubject.onNext(.populated(showDetail))
  }
  
  private func setupTVShow(_ show: TVShowDetailResult) -> TVShowDetailInfo {
    return TVShowDetailInfo(
      id: show.id,
      backDropPath: show.getbackDropPathURL(),
      nameShow: show.name,
      yearsRelease: show.releaseYears,
      duration: show.episodeDuration,
      genre: show.genreIds?.first?.name,
      numberOfEpisodes: (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : "",
      posterPath: show.getposterPathURL(),
      overView: show.overview,
      score: (show.voteAverage != nil) ? String(show.voteAverage!) : "",
      countVote: (show.voteCount != nil) ? String(show.voteCount!) : "")
  }
}

// MARK: - ViewState

extension TVShowDetailViewModel {
  
  enum ViewState {
    
    case loading
    case populated(TVShowDetailInfo)
    case empty
    case error(String)
  }
}

// MARK: - ViewModel Base

extension TVShowDetailViewModel {
  
  public struct TVShowDetailInfo {
    var id: Int
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
  }
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<ViewState>
  }
}

// MARK: - Stepper

extension TVShowDetailViewModel: Stepper {
  
  public func navigateTo(step: Step) {
    steps.accept(step)
  }
  
  public func navigateToSeasons() {
    steps.accept( ShowDetailsStep.seasonsAreRequired(withId: showId) )
  }
}
