//
//  Created by Jeans on 1/14/20.
//

import Combine
import NetworkingInterface

public protocol FetchTVShowsUseCase {
  func execute(request: FetchTVShowsUseCaseRequestValue) async -> TVShowPage?
}

public struct FetchTVShowsUseCaseRequestValue {
  public let page: Int

  public init(page: Int) {
    self.page = page
  }
}
