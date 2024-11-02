//
//  Created by Jeans Ruiz on 1/11/24.
//

import Foundation
import Combine

#if DEBUG
public final class FakeShowsVisitedLocalRepository: ShowsVisitedLocalRepositoryProtocol {

  public init() {}

  public func saveShow(id: Int, pathImage: String){

  }

  public func fetchVisitedShows() -> [ShowVisited] {
    return []
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher()
  }
}
#endif
