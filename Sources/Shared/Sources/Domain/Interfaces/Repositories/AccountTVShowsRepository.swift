//
//  Created by Jeans Ruiz on 6/27/20.
//

public protocol AccountTVShowsRepository {
  func fetchFavoritesShows(page: Int) async throws -> TVShowPage
  func fetchWatchListShows(page: Int) async throws -> TVShowPage
}
