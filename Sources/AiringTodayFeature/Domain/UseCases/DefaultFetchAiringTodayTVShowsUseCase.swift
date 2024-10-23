//
//  Created by Jeans Ruiz on 6/28/20.
//

import Combine
import Shared
import NetworkingInterface

final class DefaultFetchAiringTodayTVShowsUseCase: FetchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository

  init(tvShowsPageRepository: TVShowsPageRepository) {
    self.tvShowsPageRepository = tvShowsPageRepository
  }

  func execute(request: FetchTVShowsUseCaseRequestValue) async -> TVShowPage? {
    return await tvShowsPageRepository.fetchAiringTodayShows(page: request.page)
  }
}
