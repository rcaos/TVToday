//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared

final class TVShowDetailViewModel {
  
  private let fetchLoggedUser: FetchLoggedUser
  
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  
  private let fetchTvShowState: FetchTVAccountStates
  
  private let markAsFavoriteUseCase: MarkAsFavoriteUseCase
  
  private let saveToWatchListUseCase: SaveToWatchListUseCase
  
  private weak var coordinator: TVShowDetailCoordinatorProtocol?
  
  private let showId: Int
  
  private var viewStateObservableSubject = BehaviorSubject<ViewState>(value: .loading)
  
  private var isFavoriteSubject = BehaviorSubject<Bool>(value: false)
  
  private var isWatchListSubject = BehaviorSubject<Bool>(value: false)
  
  private var isLoadingFavoriteSubject = BehaviorSubject<Bool>(value: false)
  
  private var isLoadingWatchList = BehaviorSubject<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Public
  
  var input: Input
  
  var output: Output
  
  // MARK: - Initializers
  
  init(_ showId: Int,
       fetchLoggedUser: FetchLoggedUser,
       fetchDetailShowUseCase: FetchTVShowDetailsUseCase,
       fetchTvShowState: FetchTVAccountStates,
       markAsFavoriteUseCase: MarkAsFavoriteUseCase,
       saveToWatchListUseCase: SaveToWatchListUseCase,
       coordinator: TVShowDetailCoordinatorProtocol?) {
    self.showId = showId
    self.fetchLoggedUser = fetchLoggedUser
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchTvShowState = fetchTvShowState
    self.markAsFavoriteUseCase = markAsFavoriteUseCase
    self.saveToWatchListUseCase = saveToWatchListUseCase
    self.coordinator = coordinator
    
    self.input = Input()
    self.output = Output(
      viewState: viewStateObservableSubject.asObservable(),
      isFavorite: isFavoriteSubject.asObservable(),
      isWatchList: isWatchListSubject.asObservable())
    
    subscribe()
  }
  
  deinit {
    print("deinit \(Self.self)")
  }
  
  // MARK: - Private
  
  public func isUserLogged() -> Bool {
    return fetchLoggedUser.execute() == nil ? false : true
  }
  
  fileprivate func subscribe() {
    subscribeToViewAppears()
    subscribeButtonsWhenPopulated()
  }
  
  fileprivate func subscribeButtonsWhenPopulated() {
    viewStateObservableSubject
      .subscribe(onNext: { [weak self] viewState in
        switch viewState {
        case .populated:
          self?.subscribeFavoriteTap()
          self?.subscribeWatchListTap()
        default:
          break
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Subscriptions
  
  fileprivate func subscribeToViewAppears() {
    if isUserLogged() {
      requestTVShowDetaisAndState()
    } else {
      requestTVShowDetails()
    }
  }
  
  // MARK: - Handle Favorite Tap Button ❤️
  
  fileprivate func subscribeFavoriteTap() {
    let requestFavorite = input.tapFavoriteButton
      .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
      .withLatestFrom(isLoadingFavoriteSubject)
      .filter { $0 == false }
      .withLatestFrom(isFavoriteSubject)
      .flatMap { [weak self] (isFavorite) -> Observable<Result<Bool, Error>> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
        
        self?.isLoadingFavoriteSubject.onNext(true)
        return strongSelf.markAsFavorite(state: isFavorite)
    }
    .share()
    
    requestFavorite
      .subscribe(onNext: { [weak self] (response) in
        switch response {
        case .success(let newState):
          self?.isFavoriteSubject.onNext(newState)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    requestFavorite
      .flatMap { _ in return Observable.just(false) }
      .bind(to: isLoadingFavoriteSubject)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Handle Wath List Button Tap 🎦
  
  fileprivate func subscribeWatchListTap() {
    let requestFavorite = input.tapWatchedButton
      .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
      .withLatestFrom(isLoadingWatchList)
      .filter { $0 == false }
      .withLatestFrom(isWatchListSubject)
      .flatMap { [weak self] (isFavorite) -> Observable<Result<Bool, Error>> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
        
        self?.isLoadingWatchList.onNext(true)
        return strongSelf.saveToWatchList(state: isFavorite)
    }
    .share()
    
    requestFavorite
      .subscribe(onNext: { [weak self] (response) in
        switch response {
        case .success(let newState):
          self?.isWatchListSubject.onNext(newState)
        default:
          break
        }
      })
      .disposed(by: disposeBag)
    
    requestFavorite
      .flatMap { _ in return Observable.just(false) }
      .bind(to: isLoadingWatchList)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Request For Guest Users
  
  fileprivate func requestTVShowDetails() {
    input.didLoadView
      .filter { $0 == true }
      .flatMap { [weak self] _ -> Observable<(TVShowDetailResult)> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
        return strongSelf.fetchShowDetails()
    }
    .flatMap { [weak self] (detailShow) -> Observable<ViewState> in
      guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
      return Observable.just( .populated( strongSelf.setupTVShow(detailShow)) )
    }
    .do(onError: { [weak self] error in
      self?.viewStateObservableSubject.onNext( .error(error.localizedDescription) )
    })
      .bind(to: viewStateObservableSubject)
      .disposed(by: disposeBag)
  }
  
  // MARK: - Request For Logged Users
  
  fileprivate func requestTVShowDetaisAndState() {
    let multipleRequest = Observable.zip(fetchShowDetails(), fetchTVShowState())

    let responses =
      input.didLoadView
        .filter { $0 == true }
        .flatMap { _ -> Observable<(TVShowDetailResult, TVShowAccountStateResult)> in
          return multipleRequest
      }.share()

    responses
      .flatMap { [weak self] (detailShow, _ ) -> Observable<ViewState> in
        guard let strongSelf = self else { return Observable.error(CustomError.genericError) }
        return Observable.just( .populated( strongSelf.setupTVShow(detailShow)) )
    }
    .do(onError: { [weak self] error in
      self?.viewStateObservableSubject.onNext( .error(error.localizedDescription) )
    })
      .bind(to: viewStateObservableSubject)
      .disposed(by: disposeBag)

    responses
      .flatMap { (_, stateShow) -> Observable<Bool> in
        return Observable.just(stateShow.isFavorite)
    }
    .bind(to: isFavoriteSubject)
    .disposed(by: disposeBag)

    responses
      .flatMap { (_, stateShow) -> Observable<Bool> in
        return Observable.just(stateShow.isWatchList)
    }
    .bind(to: isWatchListSubject)
    .disposed(by: disposeBag)
  }
  
  // MARK: - Observables
  
  fileprivate func fetchShowDetails() -> Observable<TVShowDetailResult> {
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: showId)
    return fetchDetailShowUseCase.execute(requestValue: request)
  }
  
  fileprivate func fetchTVShowState() -> Observable<TVShowAccountStateResult> {
    let request = FetchTVAccountStatesRequestValue(showId: showId)
    return fetchTvShowState.execute(requestValue: request)
  }
  
  fileprivate func markAsFavorite(state: Bool) -> Observable<Result<Bool, Error>> {
    let request = MarkAsFavoriteUseCaseRequestValue(showId: showId, favorite: !state)
    return markAsFavoriteUseCase.execute(requestValue: request)
  }
  
  fileprivate func saveToWatchList(state: Bool) -> Observable<Result<Bool, Error>> {
    let request = SaveToWatchListUseCaseRequestValue(showId: showId, watchList: !state)
    return saveToWatchListUseCase.execute(requestValue: request)
  }
  
  // MARK: - Transform Response for the View
  
  fileprivate func setupTVShow(_ show: TVShowDetailResult) -> TVShowDetailInfo {
    return TVShowDetailInfo(
      id: show.id,
      backDropPath: show.backDropPathURL,
      nameShow: show.name,
      yearsRelease: show.releaseYears,
      duration: show.episodeDuration,
      genre: show.genreIds?.first?.name,
      numberOfEpisodes: (show.numberOfEpisodes != nil) ? String(show.numberOfEpisodes!) : "",
      posterPath: show.posterPathURL,
      overView: show.overview,
      score: (show.voteAverage != nil) ? String(show.voteAverage!) : "",
      countVote: (show.voteCount != nil) ? String(show.voteCount!) : "")
  }
}

// MARK: - ViewState

extension TVShowDetailViewModel {
  
  enum ViewState: Equatable {
    case loading
    case populated(TVShowDetailInfo)
    case error(String)
    
    static public func == (lhs: ViewState, rhs: ViewState) -> Bool {
      switch (lhs, rhs) {
      case (.loading, .loading):
        return true
      case (let .populated(lDetail), let .populated(rDetail)):
        return lDetail.id == rDetail.id
      case (.error, .error):
        return true
      default:
        return false
      }
    }
  }
}

// MARK: - BaseViewModel

extension TVShowDetailViewModel: BaseViewModel {
  
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
  
  public struct Input {
    let tapFavoriteButton = PublishSubject<Void>()
    let tapWatchedButton = PublishSubject<Void>()
    let didLoadView = BehaviorSubject<Bool>(value: false)
  }
  
  public struct Output {
    let viewState: Observable<ViewState>
    let isFavorite: Observable<Bool>
    let isWatchList: Observable<Bool>
  }
}

// MARK: - Navigation

extension TVShowDetailViewModel {
  
  public func navigateToSeasons() {
    navigateTo(step: .seasonsAreRequired(withId: showId) )
  }
  
  public func viewDidFinish() {
    navigateTo(step: .detailViewDidFinish)
  }
  
  fileprivate func navigateTo(step: ShowDetailsStep) {
    coordinator?.navigate(to: step)
  }
}
