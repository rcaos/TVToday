//
//  Created by Jeans Ruiz on 7/3/20.
//

import Shared

public protocol FetchVisitedShowsUseCase {
  func execute() -> [ShowVisited]
}

public final class DefaultFetchVisitedShowsUseCase: FetchVisitedShowsUseCase {

  private let showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol

  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
  }

  public func execute() -> [ShowVisited] {
    return showsVisitedLocalRepository.fetchVisitedShows()
  }
}
