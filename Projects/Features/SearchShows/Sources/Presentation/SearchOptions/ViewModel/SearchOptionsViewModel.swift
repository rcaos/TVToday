//
//  SearchOptionsViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/7/20.
//

import Foundation
import Combine
import RxSwift
import Shared
import Persistence
import NetworkingInterface

final class SearchOptionsViewModel: SearchOptionsViewModelProtocol {

  weak var delegate: SearchOptionsViewModelDelegate?

  private let fetchGenresUseCase: FetchGenresUseCase

  private let fetchVisitedShowsUseCase: FetchVisitedShowsUseCase

  private let recentVisitedShowsDidChange: RecentVisitedShowDidChangeUseCase

  private let viewStateObservableSubject = BehaviorSubject<SearchViewState>(value: .loading)

  private let dataSourceObservableSubject = BehaviorSubject<[SearchOptionsSectionModel]>(value: [])

  private let genres: [Genre] = []

  private let visitedShows: [ShowVisited] = []

  private let disposeBag = DisposeBag()
  private var cancelables = Set<AnyCancellable>()

  var viewState: Observable<SearchViewState>

  var dataSource: Observable<[SearchOptionsSectionModel]>

  // MARK: - Initializer
  init(fetchGenresUseCase: FetchGenresUseCase,
       fetchVisitedShowsUseCase: FetchVisitedShowsUseCase,
       recentVisitedShowsDidChange: RecentVisitedShowDidChangeUseCase) {
    self.fetchGenresUseCase = fetchGenresUseCase
    self.fetchVisitedShowsUseCase = fetchVisitedShowsUseCase
    self.recentVisitedShowsDidChange = recentVisitedShowsDidChange

    viewState = viewStateObservableSubject.asObservable()
    dataSource = dataSourceObservableSubject.asObservable()
  }

  // MARK: - Public
  public func viewDidLoad() {
    fetchGenresAndRecentShows()
  }

  public func modelIsPicked(with item: SearchSectionItem) {
    switch item {
    case .genres(items: let genre):
      delegate?.searchOptionsViewModel(self, didGenrePicked: genre.id, title: genre.name)
    default:
      break
    }
  }

  // MARK: - Private
  private func fetchRecentShows() -> AnyPublisher<[ShowVisited], CustomError> {
    return fetchVisitedShowsUseCase.execute(requestValue: FetchVisitedShowsUseCaseRequestValue())
  }

  private func fetchGenres() -> AnyPublisher<GenreListResult, CustomError> {
    return fetchGenresUseCase.execute(requestValue: FetchGenresUseCaseRequestValue())
      .mapError { error -> CustomError in return CustomError.transferError(error) }
      .eraseToAnyPublisher()
  }

  private func recentShowsDidChanged() -> AnyPublisher<[ShowVisited], CustomError> {
    return recentVisitedShowsDidChange.execute()
      .filter { $0 }
      .flatMap { [weak self] _ -> AnyPublisher<[ShowVisited], CustomError> in
        guard let strongSelf = self else { return Just([]).setFailureType(to: CustomError.self).eraseToAnyPublisher() }
        return strongSelf.fetchRecentShows()
      }
      .eraseToAnyPublisher()
  }

  private func fetchGenresAndRecentShows() {
    Publishers.CombineLatest(
      recentShowsDidChanged(),
      fetchGenres()
    )
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { [weak self] completion in
        switch completion {
        case let .failure(error):
          self?.viewStateObservableSubject.onError(error)
        case .finished:
          break
        }
      },
            receiveValue: { [weak self] (visited, resultGenre) in
        guard let strongSelf = self else { return }
        strongSelf.processFetched(for: resultGenre)
        strongSelf.createSectionModel(showsVisited: visited, genres: resultGenre.genres ?? [])
      })
      .store(in: &cancelables)
  }

  private func processFetched(for response: GenreListResult) {
    let fetchedGenres = (response.genres ?? [])
    if fetchedGenres.isEmpty {
      viewStateObservableSubject.onNext(.empty)
    } else {
      viewStateObservableSubject.onNext( .populated )
    }
  }

  private func createSectionModel(showsVisited: [ShowVisited], genres: [Genre]) {

    var dataSource: [SearchOptionsSectionModel] = []

    let showsSectionItem = mapRecentShowsToSectionItem(recentsShows: showsVisited)

    if let recentShowsSection = showsSectionItem {
      dataSource.append(.showsVisited(items: [recentShowsSection]))
    }

    let genresSectionItem = createSectionFor(genres: genres)

    if !genresSectionItem.isEmpty {
      dataSource.append(.genres(items: genresSectionItem))
    }

    dataSourceObservableSubject.onNext(dataSource)
  }

  private func createSectionFor(genres: [Genre] ) -> [SearchSectionItem] {
    return genres
      .map { GenreViewModel(genre: $0)  }
      .map { SearchSectionItem.genres(items: $0) }
  }

  private func mapRecentShowsToSectionItem(recentsShows: [ShowVisited]) -> SearchSectionItem? {

    let visitedModel = VisitedShowViewModel(shows: recentsShows)
    visitedModel.delegate = self

    return recentsShows.isEmpty ? nil : .showsVisited(items: visitedModel)
  }
}

// MARK: - VisitedShowViewModelDelegate
extension SearchOptionsViewModel: VisitedShowViewModelDelegate {
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModelProtocol, didSelectRecentlyVisitedShow id: Int) {
    delegate?.searchOptionsViewModel(self, didRecentShowPicked: id)
  }
}
