//
//  Created by Jeans Ruiz on 13/05/22.
//

import Combine
import NetworkingInterface

//wip todo clean this
public protocol TVShowsRemoteDataSourceProtocol {
//  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
//  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
//  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPageDTO, DataTransferError>

  func fetchAiringTodayShows(page: Int) async throws -> TVShowPageDTO
  func fetchPopularShows(page: Int) async throws -> TVShowPageDTO
  func fetchShowsByGenre(genreId: Int, page: Int) async throws -> TVShowPageDTO
}
