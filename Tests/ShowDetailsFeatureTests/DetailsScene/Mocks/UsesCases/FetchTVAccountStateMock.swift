//
//  Created by Jeans Ruiz on 8/4/20.
//

import Foundation
import Combine
import NetworkingInterface
import Shared
@testable import ShowDetailsFeature

class FetchTVAccountStateMock: FetchTVAccountStates {

  var result: TVShowAccountStatus?
  var error: ApiError?

  func execute(request: FetchTVAccountStatesRequestValue) async throws -> TVShowAccountStatus {
    if let error = error {
      throw error
    }

    if let result = result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "Mock", code: 404, userInfo: nil))
    }
  }
}
