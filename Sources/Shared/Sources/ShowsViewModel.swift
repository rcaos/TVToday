//
//  Created by Jeans on 9/16/19.
//

import Foundation
import Combine
import CombineSchedulers
import NetworkingInterface

public protocol ShowsViewModel: AnyObject {
  associatedtype MovieCellViewModel: Equatable

  var fetchTVShowsUseCase: FetchTVShowsUseCase { get }
  var shows: [TVShowPage.TVShow] { get set }
  var showsCells: [MovieCellViewModel] { get set }
  var viewStateObservableSubject: CurrentValueSubject<SimpleViewState<MovieCellViewModel>, Never> { get }
  var scheduler: AnySchedulerOf<DispatchQueue> { get }
  var disposeBag: Set<AnyCancellable> { get set }
  func mapToCell(entities: [TVShowPage.TVShow]) -> [MovieCellViewModel]
}

extension ShowsViewModel {

  public func getShows(for page: Int, showLoader: Bool = true) async {
    if viewStateObservableSubject.value.isInitialPage, showLoader {
      viewStateObservableSubject.send(.loading)
    }

    let request = FetchTVShowsUseCaseRequestValue(page: page)
    if let showPage = await fetchTVShowsUseCase.execute(request: request) {
      processFetched(for: showPage, currentPage: page)
    } else {
      handleError(DataTransferError.noResponse)
    }
  }

  private func handleError(_ error: DataTransferError) {
    if viewStateObservableSubject.value.isInitialPage {
      viewStateObservableSubject.send(.error(error.localizedDescription))
    }
  }

  private func processFetched(for response: TVShowPage, currentPage: Int) {
    if currentPage == 1 {
      shows.removeAll()
    }

    self.shows.append(contentsOf: response.showsList)

    if self.shows.isEmpty {
      viewStateObservableSubject.send(.empty)
      return
    }

    let cellsShows = mapToCell(entities: shows)

    if response.hasMorePages {
      viewStateObservableSubject.send( .paging(cellsShows, next: response.nextPage) )
    } else {
      viewStateObservableSubject.send( .populated(cellsShows) )
    }
  }
}
