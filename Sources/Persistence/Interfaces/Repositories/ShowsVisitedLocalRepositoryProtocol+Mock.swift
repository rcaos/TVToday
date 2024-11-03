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
    return [
      .init(id: 01, pathImage: "https://image.tmdb.org/t/p/w500/4EYPN5mVIhKLfxGruy7Dy41dTVn.jpg"),
      .init(id: 02, pathImage: "https://image.tmdb.org/t/p/w200/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg"),
      .init(id: 03, pathImage: "https://image.tmdb.org/t/p/w200/4EYPN5mVIhKLfxGruy7Dy41dTVn.jpg"),
      .init(id: 04, pathImage: "https://image.tmdb.org/t/p/w200/Ap86RyRhP7ikeRCpysnfC9PO2H0.jpg")
    ]
  }

  #warning("todo, use AsyncStream")
  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return Just(true).eraseToAnyPublisher()
  }
}
#endif
