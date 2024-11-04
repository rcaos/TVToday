//
//  Created by Jeans Ruiz on 13/05/22.
//

public protocol AccountTVShowsRemoteDataSourceProtocol {
  func fetchFavoritesShows(page: Int, userId: Int, sessionId: String) async throws -> TVShowPageDTO
  func fetchWatchListShows(page: Int, userId: Int, sessionId: String) async throws -> TVShowPageDTO
}
