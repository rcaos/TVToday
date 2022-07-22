//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import CombineSchedulers
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
  private let scheduler: AnySchedulerOf<DispatchQueue>
  private var disposeBag = Set<AnyCancellable>()

  private var currentResultShows: [TVShowPage.TVShow] = []

  // MARK: - Init
  init(searchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchesUseCase: FetchSearchesUseCase,
       scheduler: AnySchedulerOf<DispatchQueue> = .main) {
    self.searchTVShowsUseCase = searchTVShowsUseCase
    self.fetchRecentSearchesUseCase = fetchRecentSearchesUseCase
    self.scheduler = scheduler
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
      .receive(on: scheduler)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] query in
        self?.fetchShows(with: query)
      })
      .store(in: &disposeBag)
  }

  private func subscribeToRecentsShowsChange() {
    viewState
      .removeDuplicates()
      .filter { $0 == .initial }
      .flatMap { [fetchRecentSearchesUseCase] _ -> AnyPublisher<[Search], ErrorEnvelope> in
        return fetchRecentSearchesUseCase.execute(requestValue: FetchSearchesUseCaseRequestValue())
      }
      .receive(on: scheduler)
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
      .receive(on: scheduler)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewState.send(.error(error.localizedDescription))  // MARK: - TODO, test recovery after an Error
        case .finished:
          break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(for: result)
      })
      .store(in: &disposeBag)
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
