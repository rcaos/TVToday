//
//  Created by Jeans Ruiz on 8/7/20.
//

import Foundation
import Combine
import NetworkingInterface
@testable import SearchShowsFeature

final class FetchGenresUseCaseMock: FetchGenresUseCase {
  var error: ApiError?
  var result: GenreList?

  func execute() async throws -> GenreList {
    if let error = error {
      throw error
    }

    if let genreList = result {
      return genreList
    } else {
      throw ApiError(error: NSError(domain: "Mock", code: 404, userInfo: nil))
    }

  }
}
