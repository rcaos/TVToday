//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Foundation
import NetworkingInterface
import Persistence
import Shared
import UI

public protocol SearchTVShowsUseCase {
  func execute(request: SearchTVShowsUseCaseRequestValue) async throws -> TVShowPage
}

public struct SearchTVShowsUseCaseRequestValue {
  public let query: String
  public let page: Int
}

// MARK: - SearchTVShowsUseCase
final class DefaultSearchTVShowsUseCase: SearchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository
  private let searchsLocalRepository: SearchLocalRepositoryProtocol

  public init(
    tvShowsPageRepository: TVShowsPageRepository,
    searchsLocalRepository: SearchLocalRepositoryProtocol
  ) {
    self.tvShowsPageRepository = tvShowsPageRepository
    self.searchsLocalRepository = searchsLocalRepository
  }

  func execute(request: SearchTVShowsUseCaseRequestValue) async throws -> TVShowPage {
    let showsPage = await tvShowsPageRepository.searchShowsFor(query: request.query, page: request.page)
    if request.page == 1 {
      try await searchsLocalRepository.saveSearch(query: request.query)
    }

    if let shows = showsPage {
      return shows
    } else {
      throw NSError(domain: "SearchTVShowsUseCase", code: 0, userInfo: nil)
    }
  }
}
