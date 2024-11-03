//
//  Created by Jeans Ruiz on 7/7/20.
//

import Algorithms
import Foundation
import Combine
import Shared
import Persistence
import NetworkingInterface

final class SearchOptionsViewModel: SearchOptionsViewModelProtocol {

  weak var delegate: SearchOptionsViewModelDelegate?

  private let fetchGenresUseCase: FetchGenresUseCase
  private let fetchVisitedShowsUseCase: () -> FetchVisitedShowsUseCase
  private let recentVisitedShowsDidChange: () -> RecentVisitedShowDidChangeUseCase

  let viewState = CurrentValueSubject<SearchViewState, Never>(.loading)
  let dataSource = CurrentValueSubject<[SearchOptionsSectionModel], Never>([])

  private var disposeBag = Set<AnyCancellable>()

  init(
    fetchGenresUseCase: FetchGenresUseCase,
    fetchVisitedShowsUseCase: @escaping () -> FetchVisitedShowsUseCase,
    recentVisitedShowsDidChange: @escaping () -> RecentVisitedShowDidChangeUseCase
  ) {
    self.fetchGenresUseCase = fetchGenresUseCase
    self.fetchVisitedShowsUseCase = fetchVisitedShowsUseCase
    self.recentVisitedShowsDidChange = recentVisitedShowsDidChange
//    self.scheduler = scheduler
  }

  // MARK: - Public
  public func viewDidLoad() async {
    await fetchGenresAndRecentShows()
    subscribeToRecentShowsChanges()
  }

  private func fetchGenresAndRecentShows() async {
    do {
      let resultsGenre = try await fetchGenresUseCase.execute()
      if resultsGenre.genres.isEmpty {
        viewState.send(.empty)
      } else {
        viewState.send(.populated )
        let visitedShows = fetchVisitedShowsUseCase().execute()
        createSectionModel(showsVisited: visitedShows, genres: resultsGenre.genres.uniqued(on: \.id))
      }
    } catch {
      viewState.send(.error("error fetching genres")) // todo, recover error
    }
  }

  public func modelIsPicked(with item: SearchSectionItem) {
    switch item {
    case .genres(items: let genre):
      delegate?.searchOptionsViewModel(self, didGenrePicked: genre.id, title: genre.name)
    default:
      break
    }
  }

  private func subscribeToRecentShowsChanges() {
    recentVisitedShowsDidChange().execute()
      .filter { $0 }
      .sink(receiveValue: { [weak self] _ in
        self?.fetchRecentVisitedShows()
      })
      .store(in: &disposeBag)
  }

  private func fetchRecentVisitedShows() {
    let recentVisitedShows = fetchVisitedShowsUseCase().execute()
    let currentGenres = dataSource.value.compactMap {
      switch $0 {
      case .genres(items: let genres):
        return genres
      case .showsVisited:
        return nil
      }
    }.flatMap { $0 }

    if let newVisitedShows = mapRecentShowsToSectionItem(recentsShows: recentVisitedShows) {
      dataSource.send(
        [.showsVisited(items: [newVisitedShows])] + [.genres(items: currentGenres)]
      )
    }
  }

  private func createSectionModel(showsVisited: [ShowVisited], genres: [Genre]) {
    var sectionModel: [SearchOptionsSectionModel] = []

    let showsSectionItem = mapRecentShowsToSectionItem(recentsShows: showsVisited)

    if let recentShowsSection = showsSectionItem {
      sectionModel.append(.showsVisited(items: [recentShowsSection]))
    }

    let genresSectionItem = createSectionFor(genres: genres)

    if !genresSectionItem.isEmpty {
      sectionModel.append(.genres(items: genresSectionItem))
    }

    dataSource.send(sectionModel)
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
