//
//  ResultsSearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import Shared
import Persistence

final class ResultsSearchViewModel: ResultsSearchViewModelProtocol {

  private let searchTVShowsUseCase: SearchTVShowsUseCase

  private let fetchRecentSearchsUseCase: FetchSearchsUseCase

  private let dataSourceObservableSubject = BehaviorSubject<[ResultSearchSectionModel]>(value: [])

  private var currentSearchSubject = BehaviorSubject<String>(value: "")

  private let viewStateObservableSubject: BehaviorSubject<ResultViewState> = .init(value: .initial)

  private var disposeBag = DisposeBag()

  // MARK: - Public Api
  let viewState: Observable<ResultViewState>
  let dataSource: Observable<[ResultSearchSectionModel]>
  weak var delegate: ResultsSearchViewModelDelegate?

  // MARK: - Init
  init(searchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchsUseCase: FetchSearchsUseCase) {
    self.searchTVShowsUseCase = searchTVShowsUseCase
    self.fetchRecentSearchsUseCase = fetchRecentSearchsUseCase

    viewState = viewStateObservableSubject.asObservable()
    dataSource = dataSourceObservableSubject.asObservable()

    subscribeToRecentsShowsChange()
    subscribeToSearchInput()
  }

  // MARK: - Public
  func searchShows(with query: String) {
    currentSearchSubject.onNext(query)
  }

  func resetSearch() {
    viewStateObservableSubject.onNext(.initial)
  }

  func recentSearchIsPicked(query: String) {
    delegate?.resultsSearchViewModel(self, didSelectRecentSearch: query)
  }

  func showIsPicked(idShow: Int) {
    delegate?.resultsSearchViewModel(self, didSelectShow: idShow)
  }

  func getViewState() -> ResultViewState {
    if let viewState = try? viewStateObservableSubject.value() {
      return viewState
    } else {
      return .empty
    }
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

  private func fetchRecentsShows() -> Observable<[Search]> {
    return fetchRecentSearchsUseCase.execute(requestValue: FetchSearchsUseCaseRequestValue())
  }

  private func subscribeToRecentsShowsChange() {
    viewStateObservableSubject
      .distinctUntilChanged()
      .filter { $0 == .initial }
      .flatMap { [weak self] _ -> Observable<[Search]> in
        guard let strongSelf = self else { return Observable.just([])}
        return strongSelf.fetchRecentsShows()
    }
    .subscribe(onNext: { [weak self] results in
      self?.createSectionModel(recentSearchs: results.map { $0.query }, resultShows: [])
    })
      .disposed(by: disposeBag)
  }

  private func fetchShows(with query: String) {
    viewStateObservableSubject.onNext(.loading)
    createSectionModel(recentSearchs: [], resultShows: [])

    let request = SearchTVShowsUseCaseRequestValue(query: query, page: 1)

    searchTVShowsUseCase.execute(requestValue: request)
      .subscribe(onNext: { [weak self] result in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: result)
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          strongSelf.viewStateObservableSubject.onNext(.error(error.localizedDescription))
      })
      .disposed(by: disposeBag)
  }

  private func processFetched(for response: TVShowResult) {
    let fetchedShows = response.results ?? []

    if fetchedShows.isEmpty {
      viewStateObservableSubject.onNext( .empty )
    } else {
      viewStateObservableSubject.onNext( .populated )
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
