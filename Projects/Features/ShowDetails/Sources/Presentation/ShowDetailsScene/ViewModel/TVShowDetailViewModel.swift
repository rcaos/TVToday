//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Combine
import Shared
import ShowDetailsInterface
import NetworkingInterface
import Foundation

protocol TVShowDetailViewModelProtocol {

  // MARK: - Input
  func viewDidLoad()
  func refreshView()
  func viewDidFinish()

  func favoriteButtonDidTapped()
  func watchedButtonDidTapped()

  // MARK: - Output
  func isUserLogged() -> Bool
  func navigateToSeasons()

  var viewState: CurrentValueSubject<TVShowDetailViewModel.ViewState, Never> { get }
  var isFavorite: CurrentValueSubject<Bool, Never> { get }
  var isWatchList: CurrentValueSubject<Bool, Never> { get }
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

  private var tapFavoriteButton: PassthroughSubject<Bool, Never>
  private var markAsFavoriteOnFlight = CurrentValueSubject<Bool, Never>(false)

  private var tapWatchedButton: PassthroughSubject<Bool, Never>

  private let closures: TVShowDetailViewModelClosures?

  // MARK: - Public Api
  let viewState = CurrentValueSubject<ViewState, Never>(.loading)

  let isFavorite = CurrentValueSubject<Bool, Never>(false)

  let isWatchList = CurrentValueSubject<Bool, Never>(false)
  private var isLoadingWatchList = CurrentValueSubject<Bool, Never>(false)

  private var disposeBag = Set<AnyCancellable>()

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

  func favoriteButtonDidTapped() {
    tapFavoriteButton.send(true)
  }

  func watchedButtonDidTapped() {
    tapWatchedButton.send(true)
  }

  // MARK: - Private
  private func subscribe() {
    subscribeToViewAppears()
    subscribeButtonsWhenPopulated()
  }

  private func subscribeButtonsWhenPopulated() {
    viewState
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] viewState in
        switch viewState {
        case .populated:
          self?.subscribeFavoriteTap()
          self?.subscribeWatchListTap()
        default:
          break
        }
      })
      .store(in: &disposeBag)
  }

  // MARK: - Subscriptions
  private func subscribeToViewAppears() {
    if isUserLogged() {
      requestTVShowDetailsAndState()
    } else {
      requestTVShowDetails()
    }
  }

  // MARK: - Handle Favorite Tap Button ❤️
  private func subscribeFavoriteTap() {
    Publishers.CombineLatest(
      tapFavoriteButton,
      markAsFavoriteOnFlight
    )
      .filter { didSendTap, isLoading in
        return didSendTap && isLoading == false
      }
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .flatMap { [weak self] _ -> AnyPublisher<Bool, DataTransferError> in
        guard let strongSelf = self else { return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() }
        strongSelf.markAsFavoriteOnFlight.send(true)
        strongSelf.tapFavoriteButton.send(false)
        return strongSelf.markAsFavorite(state: strongSelf.isFavorite.value)
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] newState in
        guard let strongSelf = self else { return }
        strongSelf.isFavorite.send(newState)
        strongSelf.closures?.updateFavoritesShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        strongSelf.markAsFavoriteOnFlight.send(false)
      })
      .store(in: &disposeBag)
  }

  // MARK: - Handle Watch List Button Tap 🎦
  private func subscribeWatchListTap() {
    Publishers.CombineLatest3(
      tapWatchedButton
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main),
      self.isLoadingWatchList,
      self.isWatchList
    )
      .filter { $0.0 == true && $0.1 == false }
      .flatMap { [weak self] (_, _, isOnWatchList) -> AnyPublisher<Bool, DataTransferError> in
        guard let strongSelf = self else { return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() }
        strongSelf.tapWatchedButton.send(false)
        strongSelf.isLoadingWatchList.send(true)
        return strongSelf.saveToWatchList(state: isOnWatchList)
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] newState in
        guard let strongSelf = self else { return }
        strongSelf.isWatchList.send(newState)
        strongSelf.closures?.updateWatchListShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        strongSelf.isLoadingWatchList.send(false)
      })
      .store(in: &disposeBag)
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
          self?.viewState.send(.error(error.localizedDescription))
        case .finished:
          break
        }
      }, receiveValue: { [weak self] detailResult in
        self?.viewState.send(
          .populated(TVShowDetailInfo(show: detailResult))
        )
      })
      .store(in: &disposeBag)
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
          self.viewState.send(.error(error.localizedDescription))
        case .finished:
          break
        }
      }, receiveValue: { [viewState] (resultDetails, _) in
        viewState.send(
          .populated(TVShowDetailInfo(show: resultDetails))
        )
      })
      .store(in: &disposeBag)

    responses
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [isFavorite, isWatchList]  (_, stateShow) in
        isFavorite.send(stateShow.isFavorite)
        isWatchList.send(stateShow.isWatchList)
      })
      .store(in: &disposeBag)
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
