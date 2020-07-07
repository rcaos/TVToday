//
//  SearchViewModel.swift
//  MyTvShows
//
//  Created by Jeans on 9/16/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import RxSwift
import RxFlow
import RxRelay
import Shared
import Persistence

import RxDataSources

final class SearchViewModel {
  
  var steps = PublishRelay<Step>()
  
  private let fetchGenresUseCase: FetchGenresUseCase
  
  private let fetchTVShowsUseCase: SearchTVShowsUseCase
  
  private let fetchVisitedShowsUseCase: FetchVisitedShowsUseCase
  
  private let fetchSearchsUseCase: FetchSearchsUseCase
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<Genre>>(value: .loading)
  
  private let dataSourceObservableSubject = BehaviorSubject<[SearchSectionModel]>(value: [])
  
  private let genres: [Genre] = []
  
  private let visitedShows: [ShowVisited] = []
  
  private let disposeBag = DisposeBag()
  
  var input: Input
  var output: Output
  
  // MARK: - Initializer
  
  init(fetchGenresUseCase: FetchGenresUseCase,
       fetchTVShowsUseCase: SearchTVShowsUseCase,
       fetchVisitedShowsUseCase: FetchVisitedShowsUseCase,
       fetchSearchsUseCase: FetchSearchsUseCase) {
    self.fetchGenresUseCase = fetchGenresUseCase
    self.fetchTVShowsUseCase = fetchTVShowsUseCase
    self.fetchVisitedShowsUseCase = fetchVisitedShowsUseCase
    self.fetchSearchsUseCase = fetchSearchsUseCase
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable(),
                         dataSource: dataSourceObservableSubject.asObservable())
  }
  
  func getVisitedShows() -> Observable<[ShowVisited]> {
    return fetchVisitedShowsUseCase.execute(requestValue: FetchVisitedShowsUseCaseRequestValue())
  }
  
  func fetchGenres() -> Observable<GenreListResult> {
    return fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue())
  }
  
  func getGenres() {
    Observable.combineLatest(getVisitedShows(), fetchGenres())
      .subscribe(onNext: { [weak self] (visited, resultGenre) in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: resultGenre)
        strongSelf.createSectionModel(showsVisited: visited, genres: resultGenre.genres ?? [])
        
        }, onError: { [weak self] error in
          guard let strongSelf = self else { return }
          print("Error to fetch Case use \(error)")
          strongSelf.viewStateObservableSubject.onNext( .error(error.localizedDescription) )
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Private
  
  private func processFetched(for response: GenreListResult) {
    let fetchedGenres = response.genres ?? []
    
    if fetchedGenres.isEmpty {
      viewStateObservableSubject.onNext(.empty)
      return
    }
    viewStateObservableSubject.onNext( .populated(fetchedGenres) )
  }
  
  fileprivate func createSectionModel(showsVisited: [ShowVisited], genres: [Genre]) {
    let showsItems = [SearchSectionItem.showsVisited(items: showsVisited)]
    let genresItems = genres.map { SearchSectionItem.genres(items: $0) }
    
    let dataSource: [SearchSectionModel] = [
      .showsVisited(header: "Shows Visited", items: showsItems),
      .genres(header: "Genres", items: genresItems)
    ]
    dataSourceObservableSubject.onNext(dataSource)
  }
  
  // MARK: - Build Models
  
  public func buildResultsSearchViewModel() -> ResultsSearchViewModel {
    return ResultsSearchViewModel(fetchTVShowsUseCase: fetchTVShowsUseCase,
                                  fetchSearchsUseCase: fetchSearchsUseCase)
  }
}

// MARK: - BaseViewModel

extension SearchViewModel: BaseViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<Genre>>
    let dataSource: Observable<[SearchSectionModel]>
  }
}

// MARK: - Stepper

extension SearchViewModel {
  
  public func modelIsPicked(with item: SearchSectionModel.Item) {
    switch item {
    case .genres(items: let genre):
      steps.accept(SearchStep.genreIsPicked(withId: genre.id))
    default:
      break
    }
  }
  
  public func showIsPicked(with showId: Int) {
    steps.accept(SearchStep.showIsPicked(withId: showId))
  }
}

extension SearchViewModel: VisitedShowViewModelDelegate {
  
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModel, didSelectRecentlyVisitedMovie id: Int) {
    showIsPicked(with: id)
  }
}

// MARK: - Refactor this, move to another file

enum SearchSectionModel {
  case
  showsVisited(header: String, items: [SearchSectionItem]),
  genres(header: String, items: [SearchSectionItem])
}

enum SearchSectionItem {
  case
  showsVisited(items: [ShowVisited]),
  genres(items: Genre)
}

extension SearchSectionModel: SectionModelType {
  typealias Item = SearchSectionItem
  
  var items: [SearchSectionItem] {
    switch self {
    case .showsVisited(_, items: let items):
      return items
    case .genres(_, items: let items):
      return items
    }
  }
  
  init(original: Self, items: [Self.Item]) {
    switch original {
    case .showsVisited(header: let header, items: _):
      self = .showsVisited(header: header, items: items)
    case .genres(header: let header, items: _):
      self = .genres(header: header, items: items)
    }
  }
}
