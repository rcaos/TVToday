//
//  Created by Jeans Ruiz on 11/05/22.
//

import Shared

public final class SearchLocalRepository {
  private let dataSource: SearchLocalDataSource
  private let loggedUserRepository: LoggedUserRepositoryProtocol

  public init(dataSource: SearchLocalDataSource, loggedUserRepository: LoggedUserRepositoryProtocol) {
    self.dataSource = dataSource
    self.loggedUserRepository = loggedUserRepository
  }
}

extension SearchLocalRepository: SearchLocalRepositoryProtocol {
  public func saveSearch(query: String) async throws {
    let userId = loggedUserRepository.getUser()?.id ?? 0
    try await dataSource.saveSearch(query: query, userId: userId)
  }

  public func fetchRecentSearches() async throws -> [Search] {
    let userId = loggedUserRepository.getUser()?.id ?? 0
    let localSearchs = try await dataSource.fetchRecentSearches(userId: userId)
    return localSearchs.map { Search(query: $0.query) }
  }
}
