//
//  LocalStorage.swift
//  
//
//  Created by Jeans Ruiz on 26/04/22.
//

import Persistence

public protocol LocalDataSourceProtocol {
  func getShowVisitedDataSource(limitStorage: Int) -> ShowsVisitedLocalDataSource
  func getRecentSearchesDataSource() -> SearchLocalDataSource
}

final public class LocalStorage: LocalDataSourceProtocol {
  private let coreDataStorage: CoreDataStorage

  public init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
  }

  public func getShowVisitedDataSource(limitStorage: Int) -> ShowsVisitedLocalDataSource {
    let store: PersistenceStore<CDShowVisited> = PersistenceStore(coreDataStorage.persistentContainer)
    return CoreDataShowVisitedStorage(limitStorage: limitStorage, store: store)
  }

  public func getRecentSearchesDataSource() -> SearchLocalDataSource {
    let store: PersistenceStore<CDRecentSearch> = PersistenceStore(coreDataStorage.persistentContainer)
    return CoreDataSearchQueriesStorage(store: store)
  }
}
