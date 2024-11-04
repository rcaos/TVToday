//
//  Created by Jeans Ruiz on 7/2/20.
//

import Combine
import CoreData
import Persistence
import Shared

final class CoreDataShowVisitedStorage {
  private let store: PersistenceStore<CDShowVisited>

  private lazy var recentsShowsStream: AsyncStream<Bool> = {
    return AsyncStream { continuation in
      self.continuation = continuation
    }
  }()
  private var continuation: AsyncStream<Bool>.Continuation?

  private let limitStorage: Int

  init(limitStorage: Int, store: PersistenceStore<CDShowVisited>) {
    self.limitStorage = limitStorage
    self.store = store
    self.store.configureResultsController(sortDescriptors: CDShowVisited.defaultSortDescriptors)
    self.store.delegate = self
  }
}

extension CoreDataShowVisitedStorage: ShowsVisitedLocalDataSource {
  public func saveShow(id: Int, pathImage: String, userId: Int) {
    store.delete(showId: id)
    store.deleteLimitStorage(userId: userId, until: limitStorage)
    store.insert(id: id, pathImage: pathImage, userId: userId)
  }

  public func fetchVisitedShows(userId: Int) -> [ShowVisitedDLO] {
    return store.findAll(for: userId).map { $0.toDomain() }
  }

  public func recentVisitedShowsDidChange() -> AsyncStream<Bool> {
    return recentsShowsStream
  }
}

// MARK: - PersistenceStoreDelegate
extension CoreDataShowVisitedStorage: PersistenceStoreDelegate {
  func persistenceStore(didUpdateEntity update: Bool) {
    continuation?.yield(update)
  }
}
