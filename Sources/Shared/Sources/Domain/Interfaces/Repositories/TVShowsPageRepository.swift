//
//  Created by Jeans on 1/14/20.
//

import Combine
import NetworkingInterface

// todo, clean this
public protocol TVShowsPageRepository {
//  func fetchAiringTodayShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchPopularShows(page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func fetchShowsByGenre(genreId: Int, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>

  func fetchAiringTodayShows(page: Int) async -> TVShowPage?
}
