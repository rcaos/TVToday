//
//  LocalStorage.swift
//  
//
//  Created by Jeans Ruiz on 26/04/22.
//

import Persistence

public protocol LocalStorageProtocol {
  func showVisitedStorage(limitStorage: Int) -> ShowsVisitedLocalRepository
  func recentsSearch() -> SearchLocalDataSource
}

final public class LocalStorage: LocalStorageProtocol {
  private let coreDataStorage: CoreDataStorage

  public init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
  }

  public func showVisitedStorage(limitStorage: Int) -> ShowsVisitedLocalRepository {
    let store: PersistenceStore<CDShowVisited> = PersistenceStore(coreDataStorage.persistentContainer)
    return CoreDataShowVisitedStorage(limitStorage: limitStorage, store: store)
  }

  public func recentsSearch() -> SearchLocalDataSource {
    let store: PersistenceStore<CDRecentSearch> = PersistenceStore(coreDataStorage.persistentContainer)
    return CoreDataSearchQueriesStorage(store: store)
  }
}
