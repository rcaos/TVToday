//
//  TVShowDetailViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import CombineSchedulers
import Shared
import ShowDetailsInterface
import NetworkingInterface

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
  private let didLoadView = CurrentValueSubject<Bool, Never>(false)   // MARK: - TODO, remove

  private let tapFavoriteButton: PassthroughSubject<Bool, Never>
  private let markAsFavoriteOnFlight = CurrentValueSubject<Bool, Never>(false)

  private let tapWatchedButton: PassthroughSubject<Bool, Never>
  private let addToWatchListOnFlight = CurrentValueSubject<Bool, Never>(false)

  private let closures: TVShowDetailViewModelClosures?

  // MARK: - Public Api
  let viewState = CurrentValueSubject<ViewState, Never>(.loading)
  let isFavorite = CurrentValueSubject<Bool, Never>(false)
  let isWatchList = CurrentValueSubject<Bool, Never>(false)

  private let scheduler: AnySchedulerOf<DispatchQueue>
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(_ showId: Int,
       fetchLoggedUser: FetchLoggedUser,
       fetchDetailShowUseCase: FetchTVShowDetailsUseCase,
       fetchTvShowState: FetchTVAccountStates,
       markAsFavoriteUseCase: MarkAsFavoriteUseCase,
       saveToWatchListUseCase: SaveToWatchListUseCase,
       coordinator: TVShowDetailCoordinatorProtocol?,
       scheduler: AnySchedulerOf<DispatchQueue> = .main,
       closures: TVShowDetailViewModelClosures? = nil) {
    self.showId = showId
    self.fetchLoggedUser = fetchLoggedUser
    self.fetchDetailShowUseCase = fetchDetailShowUseCase
    self.fetchTvShowState = fetchTvShowState
    self.markAsFavoriteUseCase = markAsFavoriteUseCase
    self.saveToWatchListUseCase = saveToWatchListUseCase
    self.coordinator = coordinator
    self.scheduler = scheduler
    self.closures = closures

    tapFavoriteButton = PassthroughSubject()
    tapWatchedButton = PassthroughSubject()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func viewDidLoad() {
    subscribe()
  }

  public func refreshView() {
    subscribeToViewAppears()
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

  // MARK: - Subscriptions
  private func subscribeToViewAppears() {
    if isUserLogged() {
      requestTVShowDetailsAndState()
    } else {
      requestTVShowDetails()
    }
  }

  private func subscribeButtonsWhenPopulated() {
    viewState
      .sink(receiveValue: { [weak self] viewState in
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

  // MARK: - Handle Favorite Tap Button ❤️
  private func subscribeFavoriteTap() {
    Publishers.CombineLatest(
      tapFavoriteButton,
      markAsFavoriteOnFlight
    )
      .filter { didSendTap, isLoading in
        return didSendTap && isLoading == false
      }
      .debounce(for: .milliseconds(300), scheduler: scheduler)
      .flatMap { [weak self] _ -> AnyPublisher<Result<Bool, DataTransferError>, Never> in
        guard let strongSelf = self else { return Empty().eraseToAnyPublisher() }
        strongSelf.markAsFavoriteOnFlight.send(true)
        strongSelf.tapFavoriteButton.send(false)
        return strongSelf.markAsFavorite(state: strongSelf.isFavorite.value)
      }
      .receive(on: scheduler)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.markAsFavoriteOnFlight.send(false)

        switch result {
        case .failure:
          break
        case .success(let newState):
          strongSelf.isFavorite.send(newState)
          strongSelf.closures?.updateFavoritesShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        }
      })
      .store(in: &disposeBag)
  }

  // MARK: - Handle Watch List Button Tap 🎦
  private func subscribeWatchListTap() {
    Publishers.CombineLatest3(
      tapWatchedButton,
      addToWatchListOnFlight,

      // different approach, same result, compared with subscribeFavoriteTap()
      isWatchList
    )
      .filter { didUserTap, isOnFlight, _ in
        return didUserTap && isOnFlight == false
      }
      .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
      .flatMap { [weak self] (_, _, isOnWatchListState) -> AnyPublisher<Bool, DataTransferError> in
        guard let strongSelf = self else { return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher() }
        strongSelf.tapWatchedButton.send(false)
        strongSelf.addToWatchListOnFlight.send(true)
        return strongSelf.saveToWatchList(state: isOnWatchListState)
      }
      .receive(on: scheduler)
      .sink(receiveCompletion: { _ in },
            receiveValue: { [weak self] newState in
        guard let strongSelf = self else { return }
        strongSelf.isWatchList.send(newState)
        strongSelf.closures?.updateWatchListShows?(TVShowUpdated(showId: strongSelf.showId, isActive: newState))
        strongSelf.addToWatchListOnFlight.send(false)
      })
      .store(in: &disposeBag)
  }

  // MARK: - Request For Guest Users
  private func requestTVShowDetails() {
    fetchShowDetails()
      .receive(on: scheduler)
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
    Publishers.Zip(fetchShowDetails(), fetchTVShowState())
      .receive(on: scheduler)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          self.viewState.send(.error(error.localizedDescription))
        case .finished:
          break
        }
      }, receiveValue: { [viewState, isFavorite, isWatchList] (resultDetails, stateShow) in
        viewState.send( .populated(TVShowDetailInfo(show: resultDetails)) )
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

  private func markAsFavorite(state: Bool) -> AnyPublisher<Result<Bool, DataTransferError>, Never> {
    let request = MarkAsFavoriteUseCaseRequestValue(showId: showId, favorite: !state)
    return markAsFavoriteUseCase.execute(requestValue: request)
      .map { .success($0) }
      .replaceError(with: .failure(DataTransferError.noResponse))
      .eraseToAnyPublisher()
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
