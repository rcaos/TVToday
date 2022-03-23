//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import Shared
import Persistence

final class ResultsSearchViewModel: ResultsSearchViewModelProtocol {
  private let searchTVShowsUseCase: SearchTVShowsUseCase
  private let fetchRecentSearchsUseCase: FetchSearchsUseCase
  private var currentSearchSubject = CurrentValueSubject<String, Never>("")  /// ?????

  let viewState  = CurrentValueSubject<ResultViewState, Never>(.initial)
  let dataSource = CurrentValueSubject<[ResultSearchSectionModel], Never>([])

  weak var delegate: ResultsSearchViewModelDelegate?
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Init
  init(searchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchsUseCase: FetchSearchsUseCase) {
    self.searchTVShowsUseCase = searchTVShowsUseCase
    self.fetchRecentSearchsUseCase = fetchRecentSearchsUseCase
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

  func showIsPicked(idShow: Int) {
    delegate?.resultsSearchViewModel(self, didSelectShow: idShow)
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
        self?.fetchShows(with: query)
      })
      .store(in: &disposeBag)
  }

  private func subscribeToRecentsShowsChange() {
    viewState
      .removeDuplicates()
      .filter { $0 == .initial }
      .flatMap { [fetchRecentSearchsUseCase] _ -> AnyPublisher<[Search], CustomError> in
        return fetchRecentSearchsUseCase.execute(requestValue: FetchSearchsUseCaseRequestValue())
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] results in
        self?.createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
      })
      .store(in: &disposeBag)
  }

  private func fetchShows(with query: String) {
    viewState.send(.loading)
    createSectionModel(recentSearchs: [], resultShows: [])

    let request = SearchTVShowsUseCaseRequestValue(query: query, page: 1)

    searchTVShowsUseCase.execute(requestValue: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewState.send(.error(error.localizedDescription))
        case .finished:
          break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(for: result)
      })
      .store(in: &disposeBag)
  }

  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []

    if fetchedShows.isEmpty {
      viewState.send( .empty )
    } else {
      viewState.send( .populated )
    }

    createSectionModel(recentSearchs: [], resultShows: fetchedShows)
  }

  private func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) {
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
