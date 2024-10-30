//
//  Created by Jeans Ruiz on 13/05/22.
//

public protocol TVShowsRemoteDataSourceProtocol {
  func fetchAiringTodayShows(page: Int) async throws -> TVShowPageDTO
  func fetchPopularShows(page: Int) async throws -> TVShowPageDTO
  func fetchShowsByGenre(genreId: Int, page: Int) async throws -> TVShowPageDTO
  func searchShowsFor(query: String, page: Int) async throws -> TVShowPageDTO
}
