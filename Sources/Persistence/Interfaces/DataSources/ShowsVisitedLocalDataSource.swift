//
//  Created by Jeans Ruiz on 11/05/22.
//

import Combine
import Shared

public protocol ShowsVisitedLocalDataSource {
  func saveShow(id: Int, pathImage: String, userId: Int)

  func fetchVisitedShows(userId: Int) -> [ShowVisitedDLO]

  // Use AsyncStream instead
  func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never>
}
