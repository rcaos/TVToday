//
//  Created by Jeans Ruiz on 6/23/20.
//

import Shared
import NetworkingInterface

public protocol MarkAsFavoriteUseCase {
  func execute(request: MarkAsFavoriteUseCaseRequestValue) async throws -> Bool
}

public struct MarkAsFavoriteUseCaseRequestValue {
  let showId: Int
  let favorite: Bool
}

public final class DefaultMarkAsFavoriteUseCase: MarkAsFavoriteUseCase {
  private let accountShowsRepository: AccountTVShowsDetailsRepository

  public init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(request: MarkAsFavoriteUseCaseRequestValue) async throws -> Bool {
    _ = try await accountShowsRepository.markAsFavorite(
      tvShowId: request.showId,
      favorite: request.favorite
    )
    return request.favorite
  }
}
