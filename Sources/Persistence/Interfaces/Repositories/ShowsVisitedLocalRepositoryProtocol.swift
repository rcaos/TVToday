//
//  Created by Jeans Ruiz on 7/2/20.
//

import Shared

public protocol ShowsVisitedLocalRepositoryProtocol {
  func saveShow(id: Int, pathImage: String)
  func fetchVisitedShows() -> [ShowVisited]
  func recentVisitedShowsDidChange() -> AsyncStream<Bool>
}
