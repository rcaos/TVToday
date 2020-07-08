//
//  SearchOptionsViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import RxSwift
import RxFlow
import Shared
import Persistence
import RxDataSources

protocol SearchOptionsViewModelDelegate: class {
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel, didGenrePicked idGenre: Int)
  
  func searchOptionsViewModel(_ searchOptionsViewModel: SearchOptionsViewModel, didRecentShowPicked idShow: Int)
}

final class SearchOptionsViewModel {
  
  weak var delegate: SearchOptionsViewModelDelegate?
  
  private let fetchGenresUseCase: FetchGenresUseCase
  
  private let fetchVisitedShowsUseCase: FetchVisitedShowsUseCase
  
  private let recentVisitedShowsDidChange: RecentVisitedShowDidChangeUseCase
  
  private let viewStateObservableSubject = BehaviorSubject<SimpleViewState<Genre>>(value: .loading)
  
  private let dataSourceObservableSubject = BehaviorSubject<[SearchOptionsSectionModel]>(value: [])
  
  private let genres: [Genre] = []
  
  private let visitedShows: [ShowVisited] = []
  
  private let disposeBag = DisposeBag()
  
  var input: Input
  
  var output: Output
  
  // MARK: - Initializer
  
  init(fetchGenresUseCase: FetchGenresUseCase,
       fetchVisitedShowsUseCase: FetchVisitedShowsUseCase,
       recentVisitedShowsDidChange: RecentVisitedShowDidChangeUseCase) {
    self.fetchGenresUseCase = fetchGenresUseCase
    self.fetchVisitedShowsUseCase = fetchVisitedShowsUseCase
    self.recentVisitedShowsDidChange = recentVisitedShowsDidChange
    
    self.input = Input()
    self.output = Output(viewState: viewStateObservableSubject.asObservable(),
                         dataSource: dataSourceObservableSubject.asObservable())
  }
  
  // MARK: - Public
  
  public func viewDidLoad() {
    fetchGenresAndRecentShows()
  }
  
  public func modelIsPicked(with item: SearchOptionsSectionModel.Item) {
    switch item {
    case .genres(items: let genreId):
      delegate?.searchOptionsViewModel(self, didGenrePicked: genreId.id)
    default:
      break
    }
  }
  
  // MARK: - Private
  
  func fetchRecentShows() -> Observable<[ShowVisited]> {
    return fetchVisitedShowsUseCase.execute(requestValue: FetchVisitedShowsUseCaseRequestValue())
  }
  
  private func fetchGenres() -> Observable<GenreListResult> {
    return fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue())
  }
  
  private func recentShowsDidChanged() -> Observable<[ShowVisited]> {
    recentVisitedShowsDidChange.execute()
      .filter { $0 }
      .flatMap { [weak self] _ -> Observable<[ShowVisited]> in
        guard let strongSelf = self else { return Observable.just([]) }
        return strongSelf.fetchRecentShows()
    }
  }
  
  private func fetchGenresAndRecentShows() {
    Observable.combineLatest(recentShowsDidChanged(), fetchGenres())
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
  
  private func processFetched(for response: GenreListResult) {
    let fetchedGenres = response.genres ?? []
    
    if fetchedGenres.isEmpty {
      viewStateObservableSubject.onNext(.empty)
    } else {
      viewStateObservableSubject.onNext( .populated(fetchedGenres) )
    }
  }
  
  private func createSectionModel(showsVisited: [ShowVisited], genres: [Genre]) {
    
    let showsSectionItem = mapRecentShowsToSectionItem(recentsShows: showsVisited)
    let genresSectionItem = genres.map { SearchSectionItem.genres(items: $0) }
    
    var dataSource: [SearchOptionsSectionModel] = []
    
    if !showsSectionItem.isEmpty {
      dataSource.append(.showsVisited(items: showsSectionItem))
    }
    if !genresSectionItem.isEmpty {
      dataSource.append(.genres(items: genresSectionItem))
    }
    
    dataSourceObservableSubject.onNext(dataSource)
  }
  
  private func mapRecentShowsToSectionItem(recentsShows: [ShowVisited]) -> [SearchSectionItem] {
    return recentsShows.isEmpty ?
      [] :
      [.showsVisited(items: recentsShows)]
  }
}

// MARK: - BaseViewModel

extension SearchOptionsViewModel {
  
  public struct Input { }
  
  public struct Output {
    let viewState: Observable<SimpleViewState<Genre>>
    let dataSource: Observable<[SearchOptionsSectionModel]>
  }
}

// MARK: - VisitedShowViewModelDelegate

extension SearchOptionsViewModel: VisitedShowViewModelDelegate {
  
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModel, didSelectRecentlyVisitedShow id: Int) {
    delegate?.searchOptionsViewModel(self, didRecentShowPicked: id)
  }
}
