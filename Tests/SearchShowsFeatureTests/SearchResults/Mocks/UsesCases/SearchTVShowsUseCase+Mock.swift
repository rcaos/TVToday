//
//  Created by Jeans Ruiz on 8/7/20.
//

import Foundation
import CommonMocks
import Combine
import SearchShowsFeature
import Shared
import NetworkingInterface

final class SearchTVShowsUseCaseMock: SearchTVShowsUseCase {
  var error: ApiError?
  var result: TVShowPage?

  func execute(request: SearchTVShowsUseCaseRequestValue) async throws -> TVShowPage {
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
