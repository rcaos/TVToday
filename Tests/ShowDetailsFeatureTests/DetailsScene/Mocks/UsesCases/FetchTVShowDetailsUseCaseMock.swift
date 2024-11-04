//
//  Created by Jeans Ruiz on 8/4/20.
//

import Foundation
import Combine
import NetworkingInterface
import Shared
@testable import ShowDetailsFeature

class FetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCase {
  var result: TVShowDetail?
  var error: ApiError?

  public func execute(request: FetchTVShowDetailsUseCaseRequestValue) async throws -> TVShowDetail {
    await Task.yield()
    if let error = error {
      throw error
    }

    if let result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "Details not Set", code: 0, userInfo: nil))
    }
  }
}
