//
//  Created by Jeans Ruiz on 7/3/20.
//

import Combine
import Shared

public protocol FetchVisitedShowsUseCase {
  func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> [ShowVisited]
}

public struct FetchVisitedShowsUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchVisitedShowsUseCase: FetchVisitedShowsUseCase {

  private let showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol

  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
  }

  public func execute(requestValue: FetchVisitedShowsUseCaseRequestValue) -> [ShowVisited] {
    return showsVisitedLocalRepository.fetchVisitedShows()
  }
}
