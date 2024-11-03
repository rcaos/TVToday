//
//  Created by Jeans Ruiz on 7/7/20.
//

public protocol RecentVisitedShowDidChangeUseCase {
  func execute() -> AsyncStream<Bool>
}

public final class DefaultRecentVisitedShowDidChangeUseCase: RecentVisitedShowDidChangeUseCase {
  private let showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol

  public init(showsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol) {
    self.showsVisitedLocalRepository = showsVisitedLocalRepository
  }

  public func execute() -> AsyncStream<Bool> {
    return showsVisitedLocalRepository.recentVisitedShowsDidChange()
  }
}
