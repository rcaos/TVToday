//
//  Created by Jeans Ruiz on 6/23/20.
//

import Shared
import NetworkingInterface

public protocol SaveToWatchListUseCase {
  func execute(request: SaveToWatchListUseCaseRequestValue) async throws -> Bool
}

public struct SaveToWatchListUseCaseRequestValue {
  let showId: Int
  let watchList: Bool
}

final class DefaultSaveToWatchListUseCase: SaveToWatchListUseCase {
  private let accountShowsRepository: AccountTVShowsDetailsRepository

  init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  public func execute(request: SaveToWatchListUseCaseRequestValue) async throws -> Bool {
    _ = try await accountShowsRepository.saveToWatchList(
      tvShowId: request.showId,
      watchedList: request.watchList
    )
    return request.watchList
  }
}
