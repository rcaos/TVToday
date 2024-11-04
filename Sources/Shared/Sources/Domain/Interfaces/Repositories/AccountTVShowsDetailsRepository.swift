//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface

public protocol AccountTVShowsDetailsRepository {
  func markAsFavorite(tvShowId: Int, favorite: Bool) async throws -> TVShowActionStatus
  func saveToWatchList(tvShowId: Int, watchedList: Bool) async throws -> TVShowActionStatus
  func fetchTVShowStatus(tvShowId: Int) async throws -> TVShowAccountStatus
}
