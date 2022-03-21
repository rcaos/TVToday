//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
import RxSwift
import Shared
import ShowDetailsInterface
import NetworkingInterface
import Foundation

protocol TVShowDetailViewModelProtocol {

  // MARK: - Input
  func viewDidLoad()
  func refreshView()
  func viewDidFinish()

  var tapFavoriteButton: PublishSubject<Void> { get }
  var tapWatchedButton: PublishSubject<Void> { get }

  // MARK: - Output
  func isUserLogged() -> Bool
  func navigateToSeasons()

  var viewState: Observable<TVShowDetailViewModel.ViewState> { get }
  var isFavorite: Observable<Bool> { get }
  var isWatchList: Observable<Bool> { get }
}

final class TVShowDetailViewModel: TVShowDetailViewModelProtocol {

  private let fetchLoggedUser: FetchLoggedUser

  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase

  private let fetchTvShowState: FetchTVAccountStates

  private let markAsFavoriteUseCase: MarkAsFavoriteUseCase

  private let saveToWatchListUseCase: SaveToWatchListUseCase

  private weak var coordinator: TVShowDetailCoordinatorProtocol?

  private let showId: Int

  private let didLoadView = CurrentValueSubject<Bool, Never>(false)

  private var viewStateObservableSubject = BehaviorSubject<ViewState>(value: .loading)

  private var isFavoriteSubject = BehaviorSubject<Bool>(value: false)

  private var isWatchListSubject = BehaviorSubject<Bool>(value: false)

  private var isLoadingFavoriteSubject = BehaviorSubject<Bool>(value: false)

  private var isLoadingWatchList = BehaviorSubject<Bool>(value: false)

  private let closures: TVShowDetailViewModelClosures?

  private let disposeBag = DisposeBag()

  private var cancelable = Set<AnyCancellable>()

  // MARK: - Public Api

  var tapFavoriteButton: PublishSubject<Void>

  var tapWatchedButton: PublishSubject<Void>

  var viewState: Observable<ViewState>

  var isFavorite: Observable<Bool>

  var isWatchList: Observable<Bool>

  // MARK: - Initializers
  init(_ showId: Int,
       fetchLoggedUser: FetchLoggedUser,
       fetchDetailShowUseCase: FetchTVShowDetailsUseCase,
       fetchTvShowState: FetchTVAccountStates,
       markAsFavoriteUseCase: MarkAsFavoriteUseCase,
       saveToWatchListUseCase: SaveToWatchListUseCase,
       coordinator: TVShowDetailCoordinatorProtocol?,
       closures: TVShowDetailViewModelClosures? = nil) {
    self.showId = showId
    self.fetchLoggedUser = fetchLoggedUser
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchTvShowState = fetchTvShowState
    self.markAsFavoriteUseCase = markAsFavoriteUseCase
    self.saveToWatchListUseCase = saveToWatchListUseCase
    self.coordinator = coordinator
    self.closures = closures

    tapFavoriteButton = PublishSubject<Void>()
    tapWatchedButton = PublishSubject<Void>()

    viewState = viewStateObservableSubject.asObservable()
    isFavorite = isFavoriteSubject.asObservable()
    isWatchList = isWatchListSubject.asObservable()

    subscribe()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func viewDidLoad() {
    didLoadView.send(true)
  }

  public func refreshView() {
    didLoadView.send(true)
  }

  public func isUserLogged() -> Bool {
    return fetchLoggedUser.execute() == nil ? false : true
  }

  // MARK: - Private
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
//    if isUserLogged() {
//      requestTVShowDetaisAndState()
//    } else {
      requestTVShowDetails()
//    }
  }

  // MARK: - Handle Favorite Tap Button ❤️
  fileprivate func subscribeFavoriteTap() {
    let requestFavorite = tapFavoriteButton
      .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
      .withLatestFrom(isLoadingFavoriteSubject)
      .filter { $0 == false }
      .withLatestFrom(isFavoriteSubject)
      .flatMap { [weak self] (isFavorite) -> Observable<Result<Bool, Error>> in
        guard let strongSelf = self else {
          return Observable.error(CustomError.genericError)
        }

        self?.isLoadingFavoriteSubject.onNext(true)
        return strongSelf.markAsFavorite(state: isFavorite)
      }
      .share()

    requestFavorite
      .subscribe(onNext: { [weak self] (response) in
        guard let strongSelf = self else { return }
        switch response {
        case .success(let newState):
          strongSelf.isFavoriteSubject.onNext(newState)
          strongSelf.closures?.updateFavoritesShows?( TVShowUpdated(showId: strongSelf.showId, isActive: newState) )
        default:
          break
        }
      })
      .disposed(by: disposeBag)

    requestFavorite
      .flatMap { _ in return Observable.just(false) }
      .subscribe { [isLoadingFavoriteSubject] event in
        isLoadingFavoriteSubject.on(event)
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Handle Wath List Button Tap 🎦
  fileprivate func subscribeWatchListTap() {
    let requestFavorite = tapWatchedButton
      .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
      .withLatestFrom(isLoadingWatchList)
      .filter { $0 == false }
      .withLatestFrom(isWatchListSubject)
      .flatMap { [weak self] (isFavorite) -> Observable<Result<Bool, Error>> in
        guard let strongSelf = self else {
          return Observable.error(CustomError.genericError)
        }

        self?.isLoadingWatchList.onNext(true)
        return strongSelf.saveToWatchList(state: isFavorite)
      }
      .share()

    requestFavorite
      .subscribe(onNext: { [weak self] (response) in
        guard let strongSelf = self else { return }
        switch response {
        case .success(let newState):
          strongSelf.isWatchListSubject.onNext(newState)
          strongSelf.closures?.updateWatchListShows?( TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        default:
          break
        }
      })
      .disposed(by: disposeBag)

    requestFavorite
      .flatMap { _ in return Observable.just(false) }
      .subscribe { [isLoadingWatchList] event in
        isLoadingWatchList.on(event)
      }
      .disposed(by: disposeBag)
  }

  // MARK: - Request For Guest Users
  private func requestTVShowDetails() {
    didLoadView
      .filter { $0 == true }
      .flatMap { _ -> AnyPublisher<TVShowDetailResult, DataTransferError> in
        return self.fetchShowDetails()
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewStateObservableSubject.onError(error)
        case .finished:
          break
        }
      }, receiveValue: { [weak self] detailResult in
        self?.viewStateObservableSubject.onNext(
          .populated(TVShowDetailInfo(show: detailResult))
        )
      })
      .store(in: &cancelable)
  }

  // MARK: - Request For Logged Users
//  fileprivate func requestTVShowDetaisAndState() {
//    typealias ResultForDetails = (Result<TVShowDetailResult, Error>)
//    typealias ResultForShowState = (Result<TVShowAccountStateResult, Error>)
//
//    let responses =
//    didLoadView
//      .filter { $0 == true }
//      .flatMap { [weak self] _ -> Observable< (ResultForDetails, ResultForShowState)> in
//        guard let strongSelf = self else {
//          return Observable.just( (.failure(CustomError.genericError), .failure(CustomError.genericError) ) )
//        }
//        return Observable.zip(strongSelf.fetchShowDetails(), strongSelf.fetchTVShowState())
//      }.share()
//
//    responses
//      .flatMap { (resultDetails, resultState ) -> Observable<ViewState> in
//
//        switch (resultDetails, resultState) {
//        case (.success(let detailResult), .success):
//          return Observable.just(.populated( TVShowDetailInfo(show: detailResult) ))
//        case (.failure(let error), _):
//          return Observable.just(.error(error.localizedDescription))
//        case (_, .failure(let error)):
//          return Observable.just(.error(error.localizedDescription))
//        }
//      }
//      .subscribe { [viewStateObservableSubject] event in
//        viewStateObservableSubject.on(event)
//      }
//      .disposed(by: disposeBag)
//
//    responses
//      .flatMap { (_, result) -> Observable<Bool> in
//        switch result {
//        case .success(let stateShow):
//          return Observable.just(stateShow.isFavorite)
//        case .failure:
//          return Observable.just(false)
//        }
//      }
//      .subscribe { [isFavoriteSubject] event in
//        isFavoriteSubject.on(event)
//      }
//      .disposed(by: disposeBag)
//
//    responses
//      .flatMap { (_, result) -> Observable<Bool> in
//        switch result {
//        case .success(let stateShow):
//          return Observable.just(stateShow.isWatchList)
//        case .failure:
//          return Observable.just(false)
//        }
//      }
//      .subscribe { [isWatchListSubject] event in
//        isWatchListSubject.on(event)
//      }
//      .disposed(by: disposeBag)
//  }

  // MARK: - Observables
  private func fetchShowDetails() -> AnyPublisher<TVShowDetailResult, DataTransferError> {
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: showId)
    return fetchDetailShowUseCase.execute(requestValue: request)
  }

  fileprivate func fetchTVShowState() -> AnyPublisher<TVShowAccountStateResult, DataTransferError> {
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
