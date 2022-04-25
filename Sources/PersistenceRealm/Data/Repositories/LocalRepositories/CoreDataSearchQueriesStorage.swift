//
//  CoreDataSearchQueriesStorage.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import CoreData
import Persistence
import Shared

public final class CoreDataSearchQueriesStorage {

  private let maxStorageLimit: Int
  private let coreDataStorage: CoreDataStorage

  public init(maxStorageLimit: Int, coreDataStorage: CoreDataStorage) {
    self.maxStorageLimit = maxStorageLimit
    self.coreDataStorage = coreDataStorage
  }
}

extension CoreDataSearchQueriesStorage: SearchLocalRepository {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Fail(error: CustomError.genericError).eraseToAnyPublisher()

    // MARK: - TODO,
    // coreDataStorage.performBackgroundTask { context in }

//    return Deferred { [store] in
//      return Future<Void, CustomError> { [store] promise in
//        let persistEntity = RealmSearchShow()
//        persistEntity.query = query
//        persistEntity.userId = userId
//
//        store.saveSearch(entitie: persistEntity) {
//          promise(.success(()))
//        }
//      }
//    }
//    .eraseToAnyPublisher()
  }

  public func fetchSearchs(userId: Int) -> AnyPublisher<[Search], CustomError> {
    return Fail(error: CustomError.genericError).eraseToAnyPublisher()

    // MARK: - TODO,
    // coreDataStorage.performBackgroundTask { context in }


//    return Just(
//      store.find(for: userId).map { $0.asDomain() }
//    )
//      .setFailureType(to: CustomError.self)
//      .eraseToAnyPublisher()
  }
}
