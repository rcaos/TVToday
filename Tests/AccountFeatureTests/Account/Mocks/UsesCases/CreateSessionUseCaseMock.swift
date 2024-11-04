//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
import NetworkingInterface
@testable import AccountFeature

final class CreateSessionUseCaseMock: CreateSessionUseCase {

  var result: Bool
  var error: ApiError?

  init(result: Bool = false, error: ApiError? = nil) {
    self.result = result
    self.error = error
  }

  func execute() async -> Bool {
    if error != nil {
      return false
    }

    return result
  }
}
