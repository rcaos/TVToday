//
//  Created by Jeans Ruiz on 11/05/22.
//

import Shared

public protocol ShowsVisitedLocalDataSource {
  func saveShow(id: Int, pathImage: String, userId: Int)
  func fetchVisitedShows(userId: Int) -> [ShowVisitedDLO]
  func recentVisitedShowsDidChange() -> AsyncStream<Bool>
}
