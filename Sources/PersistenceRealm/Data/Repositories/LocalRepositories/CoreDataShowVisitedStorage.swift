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

public final class CoreDataShowVisitedStorage {

//  private let store: PersistenceStore<RealmShowVisited>
  private let recentsShowsSubject = CurrentValueSubject<Bool, Never>(true)

  private let maxStorageLimit: Int
  private let coreDataStorage: CoreDataStorage

  public init(maxStorageLimit: Int, coreDataStorage: CoreDataStorage) {
    self.maxStorageLimit = maxStorageLimit
    self.coreDataStorage = coreDataStorage
    //    self.store.subscribeToChanges()
    //    self.store.delegate = self
  }

//  public init(realmDataStack: RealmDataStorage) {
//    self.store = PersistenceStore(realmDataStack.realm)
//    self.store.subscribeToChanges()
//    self.store.delegate = self
//  }
}

// MARK: - TODO, review, should returns a Defered + Futured or a Just ?
extension DefaultShowsVisitedLocalStorage: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Fail(error: CustomError.genericError).eraseToAnyPublisher()
//    return Deferred { [store] in
//      return Future<Void, CustomError> { [store] promise in
//        let persistEntity = RealmShowVisited()
//        persistEntity.id = id
//        persistEntity.userId = userId
//        persistEntity.pathImage = pathImage
//
//        store.saveVisit(entity: persistEntity) {
//          promise(.success(()))
//        }
//      }
//    }
//    .eraseToAnyPublisher()
  }

  public func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError> {
    return Fail(error: CustomError.genericError).eraseToAnyPublisher()
//    return Just(
//      store.find(for: userId).map { $0.asDomain() }
//    )
//      .setFailureType(to: CustomError.self)
//      .eraseToAnyPublisher()
  }

  public func recentVisitedShowsDidChange() -> AnyPublisher<Bool, Never> {
    return recentsShowsSubject.eraseToAnyPublisher()
  }
}

// MARK: - RealmDataStorageDelegate
//extension DefaultShowsVisitedLocalStorage: PersistenceStoreDelegate {
//  func persistenceStore(didUpdateEntity update: Bool) {
//    recentsShowsSubject.send(update)
//  }
//}
