//
//  Created by Jeans on 1/14/20.
//

import Combine
import NetworkingInterface

// wip
public protocol TVShowsPageRepository {
  func searchShowsFor(query: String, page: Int) -> AnyPublisher<TVShowPage, DataTransferError>

  func fetchAiringTodayShows(page: Int) async -> TVShowPage? // todo, return nil?? nahhh
  func fetchPopularShows(page: Int) async -> TVShowPage?
  func fetchShowsByGenre(genreId: Int, page: Int) async -> TVShowPage?
}
