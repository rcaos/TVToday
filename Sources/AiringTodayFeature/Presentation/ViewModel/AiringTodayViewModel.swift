//
//  Created by Jeans Ruiz on 1/05/22.
//

import Combine
import NetworkingInterface
import Shared

final class AiringTodayViewModel: AiringTodayViewModelProtocol {
  private let fetchTVShowsUseCase: () -> FetchTVShowsUseCase
  let viewStateObservableSubject = CurrentValueSubject<SimpleViewState<AiringTodayCollectionViewModel>, Never>(.loading)

  private var shows: [TVShowPage.TVShow]
  private var showsCells: [AiringTodayCollectionViewModel] = []

  private weak var coordinator: AiringTodayCoordinatorProtocol?
  private var disposeBag = Set<AnyCancellable>()

  init(
    fetchTVShowsUseCase: @escaping () -> FetchTVShowsUseCase,
    coordinator: AiringTodayCoordinatorProtocol?
  ) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.coordinator = coordinator
    shows = []
  }

  private func mapToCell(entities: [TVShowPage.TVShow]) -> [AiringTodayCollectionViewModel] {
    return entities.map { AiringTodayCollectionViewModel(show: $0) }
  }

  // MARK: Input
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

  func getCurrentViewState() -> SimpleViewState<AiringTodayCollectionViewModel> {
    return viewStateObservableSubject.value
  }

  func showIsPicked(index: Int) {
    if shows.indices.contains(index) {
      coordinator?.navigate(to: .showIsPicked(shows[index].id))
    }
  }

  // MARK: - Private
  private func getShows(for page: Int, showLoader: Bool = true) async {

    if viewStateObservableSubject.value.isInitialPage, showLoader {
      viewStateObservableSubject.send(.loading)
    }

    let request = FetchTVShowsUseCaseRequestValue(page: page)
    if let result = await fetchTVShowsUseCase().execute(request: request) {
      processFetched(for: result, currentPage: page)
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

    // Avoid duplicated elements, Maybe Can I use a Set<Hashable> instead
    response.showsList.forEach { responseItem in
      if shows.contains(where: { $0.id == responseItem.id }) == false {
        shows.append(responseItem)
      }
    }

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
}
