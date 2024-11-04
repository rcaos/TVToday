//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Persistence
import Shared
import NetworkingInterface

final class FetchVisitedShowsUseCaseMock: FetchVisitedShowsUseCase {
  var error: ApiError?
  var result: [ShowVisited]?

  public func execute() -> [ShowVisited] {
    if error != nil {
      return []
    }

    if let result = result {
      return result
    } else {
      return []
    }
  }
}
