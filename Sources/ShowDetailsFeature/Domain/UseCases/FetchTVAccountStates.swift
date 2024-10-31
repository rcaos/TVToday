//
//  Created by Jeans Ruiz on 6/23/20.
//

import Shared

protocol FetchTVAccountStates {
  func execute(request: FetchTVAccountStatesRequestValue) async throws -> TVShowAccountStatus
}

struct FetchTVAccountStatesRequestValue {
  let showId: Int
}

final class DefaultFetchTVAccountStates: FetchTVAccountStates {
  private let accountShowsRepository: AccountTVShowsDetailsRepository

  init(accountShowsRepository: AccountTVShowsDetailsRepository) {
    self.accountShowsRepository = accountShowsRepository
  }

  func execute(request: FetchTVAccountStatesRequestValue) async throws -> TVShowAccountStatus {
    return try await accountShowsRepository.fetchTVShowStatus(tvShowId: request.showId)
  }
}
