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

protocol ResultsSearchViewModelDelegate: class {
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel, didSelectShow idShow: Int)
  
  func resultsSearchViewModel(_ resultsSearchViewModel: ResultsSearchViewModel, didSelectRecentSearch query: String)
}

final class ResultsSearchViewModel {
  
  weak var delegate: ResultsSearchViewModelDelegate?
  
  private let fetchTVShowsUseCase: SearchTVShowsUseCase
  
  private let fetchRecentSearchsUseCase: FetchSearchsUseCase
  
  private let dataSourceObservableSubject = BehaviorSubject<[ResultSearchSectionModel]>(value: [])
  
  private var currentSearchSubject = BehaviorSubject<String>(value: "")
  
  private var viewStateObservableSubject: BehaviorSubject<ViewState> = .init(value: .initial)
  
  private var disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  // MARK: - Init
  
  init(fetchTVShowsUseCase: SearchTVShowsUseCase,
       fetchRecentSearchsUseCase: FetchSearchsUseCase) {
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.fetchRecentSearchsUseCase = fetchRecentSearchsUseCase
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable(),
                         dataSource: dataSourceObservableSubject.asObservable())
    
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
    
    fetchTVShowsUseCase.execute(requestValue: request)
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
    
    let cellShows = fetchedShows.map { TVShowCellViewModel(show: $0) }
    
    if cellShows.isEmpty {
      viewStateObservableSubject.onNext( .empty )
    } else {
      viewStateObservableSubject.onNext( .populated(cellShows) )
    }
    
    createSectionModel(recentSearchs: [], resultShows: cellShows)
  }
  
  private func createSectionModel(recentSearchs: [String], resultShows: [TVShowCellViewModel]) {
    let recentSearchsItem = recentSearchs.map { ResultSearchSectionItem.recentSearchs(items: $0) }
    let resultsShowsItem = resultShows.map { ResultSearchSectionItem.results(items: $0) }
    
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

extension ResultsSearchViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<ViewState>
    let dataSource: Observable<[ResultSearchSectionModel]>
  }
}

extension ResultsSearchViewModel {
  
  enum ViewState: Equatable {
    case
    initial,
    
    empty,
    
    loading,
    
    populated([TVShowCellViewModel]),
    
    error(String)
    
    static func == (lhs: ResultsSearchViewModel.ViewState, rhs: ResultsSearchViewModel.ViewState) -> Bool {
      switch (lhs, rhs) {
        
      case (.initial, .initial):
        return true
        
      case (.empty, .empty):
        return true
        
      case (.loading, .loading):
        return true
        
      case (let .populated(lhsShows), let .populated(rhsShows)):
        return lhsShows.map { $0.entity.id } == rhsShows.map { $0.entity.id }
        
      case (.error, .error):
        return true
        
      default:
        return false
      }
    }
  }
}
