//
//  Created by Jeans Ruiz on 6/27/20.
//

import Shared
import NetworkingInterface

public final class DefaultUserFavoritesShowsUseCase: FetchTVShowsUseCase {
  private let accountShowsRepository: AccountTVShowsRepository

  public init(accountShowsRepository: AccountTVShowsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(request: FetchTVShowsUseCaseRequestValue) async -> TVShowPage? {
    do {
      return try await accountShowsRepository.fetchFavoritesShows(page: request.page)
    } catch {
      return nil
    }
  }
}
