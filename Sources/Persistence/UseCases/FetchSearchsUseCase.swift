//
//  Created by Jeans Ruiz on 7/7/20.
//

import Combine
import Shared

public protocol FetchSearchesUseCase {
  func execute() async -> [Search]
}

public final class DefaultFetchSearchesUseCase: FetchSearchesUseCase {
  private let searchLocalRepository: SearchLocalRepositoryProtocol

  public init(searchLocalRepository: SearchLocalRepositoryProtocol) {
    self.searchLocalRepository = searchLocalRepository
  }

  public func execute() async -> [Search] {
    do {
      return try await searchLocalRepository.fetchRecentSearches()
    } catch {
      return []
    }
  }
}
