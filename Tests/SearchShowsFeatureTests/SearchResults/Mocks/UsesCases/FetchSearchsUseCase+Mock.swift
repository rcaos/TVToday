//
//  Created by Jeans Ruiz on 8/7/20.
//

import Foundation
import Combine
@testable import SearchShowsFeature
@testable import Shared
@testable import Persistence

final class FetchSearchsUseCaseMock: FetchSearchesUseCase {
  var error: ErrorEnvelope?
  var result: [Search]?

  public func execute() async -> [Search] {
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
