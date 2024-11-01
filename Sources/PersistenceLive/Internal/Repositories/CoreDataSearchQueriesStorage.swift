//
//  Created by Jeans Ruiz on 7/2/20.
//

import Combine
import CoreData
import Persistence
import Shared

#warning("Use SwiftData instead")
final class CoreDataSearchQueriesStorage {
  private let store: PersistenceStore<CDRecentSearch>

  public init(store: PersistenceStore<CDRecentSearch>) {
    self.store = store
  }
}

extension CoreDataSearchQueriesStorage: SearchLocalDataSource {

  public func saveSearch(query: String, userId: Int) {
    store.delete(query: query)
    store.insert(query: query, userId: userId)
  }

  public func fetchRecentSearches(userId: Int) -> [SearchDLO] {
    let recentSearchs = store.findAll(userId: userId).map { $0.toDomain() }
    return recentSearchs
  }
}
