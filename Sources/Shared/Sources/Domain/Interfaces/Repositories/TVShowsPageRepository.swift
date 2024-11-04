//
//  Created by Jeans on 1/14/20.
//

public protocol TVShowsPageRepository {
  func fetchAiringTodayShows(page: Int) async -> TVShowPage? // todo, return nil?? nahhh
  func fetchPopularShows(page: Int) async -> TVShowPage?
  func fetchShowsByGenre(genreId: Int, page: Int) async -> TVShowPage?
  func searchShowsFor(query: String, page: Int) async -> TVShowPage?
}
