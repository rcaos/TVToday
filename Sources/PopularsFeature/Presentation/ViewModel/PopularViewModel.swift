//
//  Created by Jeans Ruiz on 4/05/22.
//

import Algorithms
import Combine
import CombineSchedulers
import NetworkingInterface
import Shared
import UI

protocol PopularViewModelProtocol {
  func viewDidLoad() async
  func willDisplayRow(_ row: Int, outOf totalRows: Int) async
  func showIsPicked(index: Int)
  func refreshView() async

  // MARK: - Output
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> { get }
}

final class PopularViewModel: PopularViewModelProtocol {
  let fetchTVShowsUseCase: FetchTVShowsUseCase
  var shows: [TVShowPage.TVShow]
  var showsCells: [TVShowCellViewModel] = []
  let viewStateObservableSubject: CurrentValueSubject<SimpleViewState<TVShowCellViewModel>, Never> = .init(.loading)
  weak var coordinator: PopularCoordinatorProtocol?
  var scheduler: AnySchedulerOf<DispatchQueue>
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializers
  init(fetchTVShowsUseCase: FetchTVShowsUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main,
       coordinator: PopularCoordinatorProtocol?) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.scheduler = scheduler
    self.coordinator = coordinator
    shows = []
  }

  func viewDidLoad() async {
    await getShows(for: 1)
  }

  func willDisplayRow(_ row: Int, outOf totalRows: Int) async {
    if case .paging(_, let nextPage) = viewStateObservableSubject.value, row == totalRows - 1 {
      await getShows(for: nextPage)
    }
  }

  func refreshView() async {
    await getShows(for: 1, showLoader: false)
  }

  func showIsPicked(index: Int) {
    if shows.indices.contains(index) {
      coordinator?.navigate(to: .showIsPicked(shows[index].id))
    }
  }

  private func getShows(for page: Int, showLoader: Bool = true) async {
    if viewStateObservableSubject.value.isInitialPage, showLoader {
      viewStateObservableSubject.send(.loading)
    }

    let response = await fetchTVShowsUseCase.execute(request: .init(page: page))
    if let response {
      processFetched(for: response, currentPage: page)
    } else {
      if viewStateObservableSubject.value.isInitialPage {
        #warning("todo, change message")
        viewStateObservableSubject.send(.error("Error to load TVShows"))
      }
    }
  }

  private func processFetched(for response: TVShowPage, currentPage: Int) {
    if currentPage == 1 {
      shows.removeAll()
    }
    let uniqueShows = (shows + response.showsList).uniqued(on: \.id)
    shows = uniqueShows

    if shows.isEmpty {
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

  private func mapToCell(entities: [TVShowPage.TVShow]) -> [TVShowCellViewModel] {
    return entities.map { TVShowCellViewModel(show: $0) }
  }
}
