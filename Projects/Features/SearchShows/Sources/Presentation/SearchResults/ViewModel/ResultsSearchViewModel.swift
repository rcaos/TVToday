//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import Combine
import RxSwift
import Shared
import Persistence

final class ResultsSearchViewModel: ResultsSearchViewModelProtocol {

  private let searchTVShowsUseCase: SearchTVShowsUseCase

  private let fetchRecentSearchsUseCase: FetchSearchsUseCase

  private let dataSourceObservableSubject = BehaviorSubject<[ResultSearchSectionModel]>(value: [])

  private var currentSearchSubject = BehaviorSubject<String>(value: "")

  private var disposeBag = DisposeBag()

  private var cancelables = Set<AnyCancellable>()

  // MARK: - Public Api
  let viewStateObservableSubject = CurrentValueSubject<ResultViewState, Never>(.initial)
  let dataSource: Observable<[ResultSearchSectionModel]>
  weak var delegate: ResultsSearchViewModelDelegate?

  // MARK: - Init
  init(searchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchsUseCase: FetchSearchsUseCase) {
    self.searchTVShowsUseCase = searchTVShowsUseCase
    self.fetchRecentSearchsUseCase = fetchRecentSearchsUseCase

    dataSource = dataSourceObservableSubject.asObservable()

    subscribeToRecentsShowsChange()
    subscribeToSearchInput()
  }

  // MARK: - Public
  func searchShows(with query: String) {
    currentSearchSubject.onNext(query)
  }

  func resetSearch() {
    viewStateObservableSubject.send(.initial)
  }

  func recentSearchIsPicked(query: String) {
    delegate?.resultsSearchViewModel(self, didSelectRecentSearch: query)
  }

  func showIsPicked(idShow: Int) {
    delegate?.resultsSearchViewModel(self, didSelectShow: idShow)
  }

  func getViewState() -> ResultViewState {
    return viewStateObservableSubject.value
  }

  // MARK: - Private
  private func subscribeToSearchInput() {
    currentSearchSubject
      .filter { !$0.isEmpty }
      .subscribe(onNext: { [weak self] query in
        guard let strongSelf = self else { return }
        strongSelf.fetchShows(with: query)
      })
      .disposed(by: disposeBag)
  }

  private func subscribeToRecentsShowsChange() {
    viewStateObservableSubject
      .removeDuplicates()
      .filter { $0 == .initial }
      .flatMap { [fetchRecentSearchsUseCase] _ -> AnyPublisher<[Search], CustomError> in
        return fetchRecentSearchsUseCase.execute(requestValue: FetchSearchsUseCaseRequestValue())
      }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] results in
        self?.createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
      })
      .store(in: &cancelables)
  }

  private func fetchShows(with query: String) {
    viewStateObservableSubject.send(.loading)
    createSectionModel(recentSearchs: [], resultShows: [])

    let request = SearchTVShowsUseCaseRequestValue(query: query, page: 1)

    searchTVShowsUseCase.execute(requestValue: request)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewStateObservableSubject.send(.error(error.localizedDescription))
        case .finished:
          break
        }
      }, receiveValue: { [weak self] result in
        self?.processFetched(for: result)
      })
      .store(in: &cancelables)
  }

  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []

    if fetchedShows.isEmpty {
      viewStateObservableSubject.send( .empty )
    } else {
      viewStateObservableSubject.send( .populated )
    }

    createSectionModel(recentSearchs: [], resultShows: fetchedShows)
  }

  private func createSectionModel(recentSearchs: [String], resultShows: [TVShow]) {
    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }

    let resultsShowsItem = resultShows
      .map { TVShowCellViewModel(show: $0) }
      .map { ResultSearchSectionItem.results(items: $0) }

    var dataSource: [ResultSearchSectionModel] = []

    if !recentSearchsItem.isEmpty {
      dataSource.append(.recentSearchs(items: recentSearchsItem))
    }

    if !resultsShowsItem.isEmpty {
      dataSource.append(.results(items: resultsShowsItem))
    }

    dataSourceObservableSubject.onNext(dataSource)
  }
}
