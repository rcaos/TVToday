//
//  LocalStorage.swift
//  
//
//  Created by Jeans Ruiz on 26/04/22.
//

import Persistence

public protocol LocalStorageProtocol {
  func showVisitedStorage() -> ShowsVisitedLocalRepository
}

final public class LocalStorage: LocalStorageProtocol {
  private let coreDataStorage: CoreDataStorage

  public init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
  }

  public func showVisitedStorage() -> ShowsVisitedLocalRepository {
    let store: PersistenceStore<CDShowVisited> = PersistenceStore(coreDataStorage.persistentContainer)
    return CoreDataShowVisitedStorage(store: store)
  }
}
