//
//  TVShowListViewModel.swift
//  
//
//  Created by Jeans Ruiz on 4/05/22.
//

import Combine
import CombineSchedulers
import ShowDetailsFeatureInterface
import ShowListFeatureInterface
import NetworkingInterface
import Shared
import UI

protocol TVShowListViewModelProtocol {
  // MARK: - Input
  func viewDidLoad()
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
  func showIsPicked(index: Int)
  func refreshView()
  func viewDidFinish()

  // MARK: - Output
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> { get }
}

final class TVShowListViewModel: TVShowListViewModelProtocol {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  let viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> = .init(.loading)

  var shows: [TVShowPage.TVShow]
  var showsCells: [TVShowCellViewModel] = []

  private weak var coordinator: TVShowListCoordinatorProtocol?
  private let stepOrigin: TVShowListStepOrigin?
  var scheduler: AnySchedulerOf<DispatchQueue>
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main,
       coordinator: TVShowListCoordinatorProtocol?,
       stepOrigin: TVShowListStepOrigin? = nil) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.scheduler = scheduler
    self.coordinator = coordinator
    self.shows = []
    self.stepOrigin = stepOrigin
  }

  deinit {
    print("deinit \(Self.self)")
  }

  func mapToCell(entities: [TVShowPage.TVShow]) -> [TVShowCellViewModel] {
    return entities
      //.filter { $0.isActive } // MARK: - TODO, recover this behavior
      .map { TVShowCellViewModel(show: $0) }
  }

  // MARK: - Input
  func viewDidLoad() {
    getShows(for: 1)
  }

  func willDisplayRow(_ row: Int, outOf totalRows: Int) {
    if case .paging(_, let nextPage) = viewStateObservableSubject.value, row == totalRows - 1 {
      getShows(for: nextPage)
    }
  }

  func refreshView() {
    getShows(for: 1, showLoader: false)
  }

  // MARK: - Navigation
  public func showIsPicked(index: Int) {
    if shows.indices.contains(index) {
      let step = TVShowListStep.showIsPicked(showId: shows[index].id, stepOrigin: stepOrigin, closure: updateTVShow)
      coordinator?.navigate(to: step)
    }
  }

  public func viewDidFinish() {
    coordinator?.navigate(to: .showListDidFinish)
  }

  // MARK: - Updated List from Show Details (Deleted Favorite, Delete WatchList)
  private func updateTVShow(_ updated: TVShowUpdated) {
    // MARK: - TODO, during refactor, need to fix this behavior, maybe use a Memory Repository.
    print("refresh show= [\(updated)]")
//    for index in shows.indices where shows[index].id == updated.showId {
//      shows[index].isActive = updated.isActive
//    }
//    refreshCells()
  }

  private func refreshCells() {
    let cells = mapToCell(entities: shows)

    if cells.isEmpty {
      viewStateObservableSubject.send(.empty)
      return
    }

    switch viewStateObservableSubject.value {
    case .paging(_, let nextPage):
      viewStateObservableSubject.send( .paging(cells, next: nextPage) )
    case .populated:
      viewStateObservableSubject.send(.populated(cells))
    default:
      break
    }
  }

  // MARK: - Private
  private func getShows(for page: Int, showLoader: Bool = true) {

    if viewStateObservableSubject.value.isInitialPage, showLoader {
      viewStateObservableSubject.send(.loading)
    }

    let request = FetchTVShowsUseCaseRequestValue(page: page)

    fetchTVShowsUseCase.execute(requestValue: request)
      .receive(on: scheduler)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.handleError(error)
        case .finished: break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(for: result, currentPage: page)
      })
      .store(in: &disposeBag)
  }

  private func handleError(_ error: DataTransferError) {
    if viewStateObservableSubject.value.isInitialPage {
      viewStateObservableSubject.send(.error(error.localizedDescription))
    }
  }

  private func processFetched(for response: TVShowPage, currentPage: Int) {
    if currentPage == 1 {
      shows.removeAll()
    }

    self.shows.append(contentsOf: response.showsList)

    if self.shows.isEmpty {
      viewStateObservableSubject.send(.empty)
      return
    }

    let cellsShows = mapToCell(entities: shows)

    if response.hasMorePages {
      viewStateObservableSubject.send( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.send( .populated(cellsShows) )
    }
  }
}
