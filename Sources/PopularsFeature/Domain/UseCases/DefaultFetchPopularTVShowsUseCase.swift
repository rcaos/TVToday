//
//  Created by Jeans Ruiz on 6/28/20.
//

import Shared
import NetworkingInterface

final class DefaultFetchPopularTVShowsUseCase: FetchTVShowsUseCase {
  private let tvShowsPageRepository: TVShowsPageRepository

  init(tvShowsPageRepository: TVShowsPageRepository) {
    self.tvShowsPageRepository = tvShowsPageRepository
  }

  func execute(request: FetchTVShowsUseCaseRequestValue) async -> TVShowPage? {
    return await tvShowsPageRepository.fetchPopularShows(page: request.page)
  }
}
