//
//  Created by Jeans on 9/16/19.
//

import Foundation
import Combine
import Shared
import ShowDetailsFeatureInterface
import NetworkingInterface

protocol TVShowDetailViewModelProtocol {
  func viewDidLoad() async
  func refreshView() async
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

  // MARK: - Public Api
  let viewState = CurrentValueSubject<ViewState, Never>(.loading)
  let isFavorite = CurrentValueSubject<Bool, Never>(false)
  let isWatchList = CurrentValueSubject<Bool, Never>(false)

  // MARK: - Private
  private let fetchLoggedUser: FetchLoggedUser
  private let fetchDetailShowUseCase: FetchTVShowDetailsUseCase
  private let fetchTvShowState: FetchTVAccountStates
  private let markAsFavoriteUseCase: MarkAsFavoriteUseCase
  private let saveToWatchListUseCase: SaveToWatchListUseCase

  private weak var coordinator: TVShowDetailCoordinatorProtocol?

  private let showId: Int
  private let tapFavoriteButton: PassthroughSubject<Bool, Never>
  private let markAsFavoriteOnFlight = CurrentValueSubject<Bool, Never>(false)
  private var savingAsFavoriteOnFlight = false

  private let tapWatchedButton: PassthroughSubject<Bool, Never>
  private let addToWatchListOnFlight = CurrentValueSubject<Bool, Never>(false)
  private var addingToWatchListOnFlight = false

  private let closures: TVShowDetailViewModelClosures?
  private var disposeBag = Set<AnyCancellable>()

  init(
    _ showId: Int,
    fetchLoggedUser: FetchLoggedUser,
    fetchDetailShowUseCase: FetchTVShowDetailsUseCase,
    fetchTvShowState: FetchTVAccountStates,
    markAsFavoriteUseCase: MarkAsFavoriteUseCase,
    saveToWatchListUseCase: SaveToWatchListUseCase,
    coordinator: TVShowDetailCoordinatorProtocol?,
    closures: TVShowDetailViewModelClosures? = nil
  ) {
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
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func viewDidLoad() async {
    await subscribe()
  }

  public func refreshView() async {
    await subscribeToViewAppears() // todo
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
  private func subscribe() async {
    await subscribeToViewAppears()
    subscribeButtonsWhenPopulated()
  }

  // MARK: - Subscriptions
  private func subscribeToViewAppears() async{
    if isUserLogged() {
      await requestTVShowDetailsAndState()
    } else {
      await requestTVShowDetails()
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
    tapFavoriteButton
      .filter { $0 }
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.markAsFavorite()
      })
      .store(in: &disposeBag)
  }

  // MARK: - Handle Watch List Button Tap 🎦
  private func subscribeWatchListTap() {
    tapWatchedButton
      .filter { $0 }
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.saveToWatchList()
      })
      .store(in: &disposeBag)
  }

  // MARK: - Request For Guest Users
  private func requestTVShowDetails() async {
    do {
      let showDetails = try await fetchDetailShowUseCase.execute(request: .init(identifier: showId))
      viewState.send(.populated(TVShowDetailInfo(show: showDetails)))
    } catch {
      viewState.send(.error(error.localizedDescription))
    }
  }

  // MARK: - Request For Logged Users
  private func requestTVShowDetailsAndState() async {
    do {
      // todo, make requests in parallel
      let showDetails = try await fetchDetailShowUseCase.execute(request: .init(identifier: showId))
      let status = try await fetchTvShowState.execute(request: .init(showId: showId))
      viewState.send(.populated(TVShowDetailInfo(show: showDetails)))
      isFavorite.send(status.isFavorite)
      isWatchList.send(status.isWatchList)
    } catch {
      viewState.send(.error(error.localizedDescription))
    }
  }

  private func markAsFavorite() {
    Task { /// todo, check if this is the right way to do it, memory leaks?
      guard savingAsFavoriteOnFlight == false else {
        return
      }
      savingAsFavoriteOnFlight = true
      let newState = !isFavorite.value
      isFavorite.send(newState) /// optimistic update
      do {
        let request = MarkAsFavoriteUseCaseRequestValue(showId: showId, favorite: newState)
        _ = try await markAsFavoriteUseCase.execute(request: request)
        isFavorite.send(newState)
        closures?.updateFavoritesShows?(TVShowUpdated(showId: showId, isActive: newState))
      } catch {
        // todo log error
        isFavorite.send(!newState) // rollback
      }
      savingAsFavoriteOnFlight = false
    }
  }

  private func saveToWatchList() {
    Task { /// memory leaks?
      guard addingToWatchListOnFlight == false else {
        return
      }
      addingToWatchListOnFlight = true
      let newState = !isWatchList.value
      isWatchList.send(newState) /// optimistic update

      do {
        let request = SaveToWatchListUseCaseRequestValue(showId: showId, watchList: newState)
        let _ = try await saveToWatchListUseCase.execute(request: request)
        isWatchList.send(newState)
        closures?.updateWatchListShows?(TVShowUpdated(showId: showId, isActive: newState))
      } catch {
        // todo log error
        isWatchList.send(!newState) // rollback
      }
      addingToWatchListOnFlight = false
    }
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
