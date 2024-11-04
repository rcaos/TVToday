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
    if let error = error {
      throw error
    }

    if let result = result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "", code: 0, userInfo: nil))
    }
  }
}
