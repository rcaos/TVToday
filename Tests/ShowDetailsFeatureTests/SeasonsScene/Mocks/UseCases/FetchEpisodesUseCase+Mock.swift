//
//  Created by Jeans Ruiz on 8/6/20.
//

import Foundation
import Combine
import NetworkingInterface
@testable import ShowDetailsFeature

final class FetchEpisodesUseCaseMock: FetchEpisodesUseCase {
  var result: TVShowSeason?
  var error: ApiError?

  func execute(request: FetchEpisodesUseCaseRequestValue) async throws -> TVShowSeason {
    await Task.yield()
    if let error = error {
      throw error
    }

    if let result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "Season Value not set", code: 0, userInfo: nil))
    }
  }
}
