//
//  Created by Jeans Ruiz on 13/05/22.
//

public protocol TVShowsDetailsRepository {
  func fetchTVShowDetails(with showId: Int) async throws -> TVShowDetail
}
