//
//  Created by Jeans on 9/16/19.
//

import Foundation
import Combine
import Shared
import UI
import Persistence

final class ResultsSearchViewModel: ResultsSearchViewModelProtocol {
  private let searchTVShowsUseCase: SearchTVShowsUseCase
  private let fetchRecentSearchesUseCase: FetchSearchesUseCase
  private let currentSearchSubject = CurrentValueSubject<String, Never>("")

  let viewState  = CurrentValueSubject<ResultViewState, Never>(.initial)
  let dataSource = CurrentValueSubject<[ResultSearchSectionModel], Never>([])

  weak var delegate: ResultsSearchViewModelDelegate?
  private var disposeBag = Set<AnyCancellable>()

  private var currentResultShows: [TVShowPage.TVShow] = []

  // MARK: - Init
  init(
    searchTVShowsUseCase: SearchTVShowsUseCase,
    fetchRecentSearchesUseCase: FetchSearchesUseCase
  ) {
    self.searchTVShowsUseCase = searchTVShowsUseCase
    self.fetchRecentSearchesUseCase = fetchRecentSearchesUseCase
    subscribeToRecentsShowsChange()
    subscribeToSearchInput()
  }

  // MARK: - Public
  func searchShows(with query: String) {
    currentSearchSubject.send(query)
  }

  func resetSearch() {
    viewState.send(.initial)
  }

  func recentSearchIsPicked(query: String) {
    delegate?.resultsSearchViewModel(self, didSelectRecentSearch: query)
  }

  func showIsPicked(index: Int) {
    if currentResultShows.indices.contains(index) {
      delegate?.resultsSearchViewModel(self, didSelectShow: currentResultShows[index].id)
    }
  }

  func getViewState() -> ResultViewState {
    return viewState.value
  }

  // MARK: - Private
  private func subscribeToSearchInput() {
    currentSearchSubject
      .filter { !$0.isEmpty }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] query in
        self?.fetchShows(query: query)
      })
      .store(in: &disposeBag)
  }

  private func subscribeToRecentsShowsChange() {
    viewState
      .removeDuplicates()
      .filter { $0 == .initial }
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] _ in
        self?.fetchRecentSearches()
      })
      .store(in: &disposeBag)
  }

  private func fetchRecentSearches() {
    Task { /// check leaks
      let results = await fetchRecentSearchesUseCase.execute()
      createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
    }
  }

  private func fetchShows(query: String) {
    Task { [weak self] in
      await self?.fetchShows(with: query)
    }
  }

  private func fetchShows(with query: String) async {
    viewState.send(.loading)
    createSectionModel(recentSearchs: [], resultShows: [])
    do {
      let result = try await searchTVShowsUseCase.execute(request: .init(query: query, page: 1))
      processFetched(for: result)
    } catch {
      viewState.send(.error(error.localizedDescription)) // MARK: - TODO, test recovery after an Error
    }
  }

  private func processFetched(for response: TVShowPage) {
    if response.showsList.isEmpty {
      viewState.send( .empty )
    } else {
      viewState.send( .populated )
    }

    currentResultShows = response.showsList
    createSectionModel(recentSearchs: [], resultShows: response.showsList)
  }

  private func createSectionModel(recentSearchs: [String], resultShows: [TVShowPage.TVShow]) {
    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }

    let resultsShowsItem = resultShows
      .map { TVShowCellViewModel(show: $0) }
      .map { ResultSearchSectionItem.results(items: $0) }

    var sectionModel: [ResultSearchSectionModel] = []

    if !recentSearchsItem.isEmpty {
      sectionModel.append(.recentSearchs(items: recentSearchsItem))
    }

    if !resultsShowsItem.isEmpty {
      sectionModel.append(.results(items: resultsShowsItem))
    }

    dataSource.send(sectionModel)
  }
}
