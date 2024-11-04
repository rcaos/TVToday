//
//  Created by Jeans Ruiz on 8/7/20.
//

import Combine
import Persistence

final class RecentVisitedShowDidChangeUseCaseMock: RecentVisitedShowDidChangeUseCase {
  var result: Bool?

  public func execute() -> AsyncStream<Bool> {
    return AsyncStream { continuation in
      if let result = self.result {
        continuation.yield(result)
      }
      continuation.finish()
    }
  }
}
