//
//  CoreDataShowVisitedStorage.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import CoreData
import Persistence
import Shared

final class CoreDataShowVisitedStorage {
  private let store: PersistenceStore<CDShowVisited>
  private let recentsShowsSubject = CurrentValueSubject<Bool, Never>(true)

  init(store: PersistenceStore<CDShowVisited>) {
    self.store = store
    self.store.configureResultsController(sortDescriptors: CDShowVisited.defaultSortDescriptors)
    self.store.delegate = self
  }
}

extension CoreDataShowVisitedStorage: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [store] in
      return Future<Void, CustomError> { promise in
        store.delete(showId: id)
        store.insert(id: id, pathImage: pathImage, userId: userId)
        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }

  public func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError> {
    return Deferred { [store] in
      return Future<[ShowVisited], CustomError> { promise in
        let results = store.findAll(for: userId).map { $0.toDomain() }
        promise(.success(results))
      }
    }
    .eraseToAnyPublisher()
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return recentsShowsSubject.eraseToAnyPublisher()
  }
}

// MARK: - PersistenceStoreDelegate
extension CoreDataShowVisitedStorage: PersistenceStoreDelegate {
  func persistenceStore(willUpdateEntity shouldPrepare: Bool) {
    recentsShowsSubject.send(true)
  }

  func persistenceStore(didUpdateEntity update: Bool) {
    _ = 1
  }
}
