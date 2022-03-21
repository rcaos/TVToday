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

  var tapFavoriteButton: PassthroughSubject<Void, Never> { get }
  var tapWatchedButton: PassthroughSubject<Void, Never> { get }

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

  private var isFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
  private var isWatchListSubject = CurrentValueSubject<Bool, Never>(false)

  private var isLoadingFavoriteSubject = CurrentValueSubject<Bool, Never>(false)
  private var isLoadingWatchList = CurrentValueSubject<Bool, Never>(false)

  private let closures: TVShowDetailViewModelClosures?

  private var cancelable = Set<AnyCancellable>()

  // MARK: - Public Api
  var tapFavoriteButton: PassthroughSubject<Void, Never>
  var tapWatchedButton: PassthroughSubject<Void, Never>

  var viewState: Observable<ViewState>

  var isFavorite: Observable<Bool>

  var isWatchList: Observable<Bool>

  private let disposeBag = DisposeBag()

  private var cancelables = Set<AnyCancellable>()

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

    tapFavoriteButton = PassthroughSubject()
    tapWatchedButton = PassthroughSubject()

    viewState = viewStateObservableSubject.asObservable()
    isFavorite = Observable.just(false) //isFavoriteSubject.asObservable() // TODO, set this
    isWatchList = Observable.just(false) //isWatchListSubject.asObservable() // TODO, set this

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
    if isUserLogged() {
      requestTVShowDetailsAndState()
    } else {
      requestTVShowDetails()
    }
  }

  // MARK: - Handle Favorite Tap Button ❤️
  private func subscribeFavoriteTap() {
    let requestFavorite = tapFavoriteButton
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .flatMap { self.isLoadingFavoriteSubject }
      .filter { $0 == false }
      .flatMap { _ in self.isFavoriteSubject }
      .flatMap { [weak self] isFavorite -> AnyPublisher<Bool, DataTransferError> in
        guard let strongSelf = self else { return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() }
        strongSelf.isLoadingFavoriteSubject.send(true)
        return strongSelf.markAsFavorite(state: isFavorite)
      }
      .share()

    requestFavorite
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] newState in
        guard let strongSelf = self else { return }
        strongSelf.isFavoriteSubject.send(newState)
        strongSelf.closures?.updateFavoritesShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        strongSelf.isLoadingFavoriteSubject.send(false)
      })
      .store(in: &cancelables)
  }

  // MARK: - Handle Wath List Button Tap 🎦
  private func subscribeWatchListTap() {
    let requestFavorite = tapWatchedButton
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .flatMap { self.isLoadingWatchList }
      .filter { $0 == false }
      .flatMap { _ in self.isWatchListSubject }
      .flatMap { [weak self] isOnWatchList -> AnyPublisher<Bool, DataTransferError> in
        guard let strongSelf = self else { return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() }
        strongSelf.isLoadingWatchList.send(true)
        return strongSelf.saveToWatchList(state: isOnWatchList)
      }
      .share()

    requestFavorite
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] newState in
        guard let strongSelf = self else { return }
        strongSelf.isWatchListSubject.send(newState)
        strongSelf.closures?.updateWatchListShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        strongSelf.isLoadingWatchList.send(false)
      })
      .store(in: &cancelables)
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
  private func requestTVShowDetailsAndState() {
    let responses =
    didLoadView
      .filter { $0 == true }
      .flatMap { _ -> AnyPublisher<(TVShowDetailResult, TVShowAccountStateResult), DataTransferError> in
        Publishers.Zip(self.fetchShowDetails(), self.fetchTVShowState())
          .eraseToAnyPublisher()
      }
      .share()

    responses
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          self.viewStateObservableSubject.onError(error)
        case .finished:
          break
        }
      }, receiveValue: { [viewStateObservableSubject] (resultDetails, _) in
        viewStateObservableSubject.onNext(.populated(TVShowDetailInfo(show: resultDetails)))
      })
      .store(in: &cancelable)

    responses
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [isFavoriteSubject, isWatchListSubject]  (_, stateShow) in
        isFavoriteSubject.send(stateShow.isFavorite)
        isWatchListSubject.send(stateShow.isWatchList)
      })
      .store(in: &cancelable)
  }

  // MARK: - Observables
  private func fetchShowDetails() -> AnyPublisher<TVShowDetailResult, DataTransferError> {
    let request = FetchTVShowDetailsUseCaseRequestValue(identifier: showId)
    return fetchDetailShowUseCase.execute(requestValue: request)
  }

  fileprivate func fetchTVShowState() -> AnyPublisher<TVShowAccountStateResult, DataTransferError> {
    let request = FetchTVAccountStatesRequestValue(showId: showId)
    return fetchTvShowState.execute(requestValue: request)
  }

  private func markAsFavorite(state: Bool) -> AnyPublisher<Bool, DataTransferError> {
    let request = MarkAsFavoriteUseCaseRequestValue(showId: showId, favorite: !state)
    return markAsFavoriteUseCase.execute(requestValue: request)
  }

  private func saveToWatchList(state: Bool) -> AnyPublisher<Bool, DataTransferError> {
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
