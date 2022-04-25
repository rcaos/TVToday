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
  private let coreDataStorage: CoreDataStorage

  public init(coreDataStorage: CoreDataStorage) {
    self.coreDataStorage = coreDataStorage
  }
}

extension CoreDataSearchQueriesStorage: SearchLocalRepository {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [coreDataStorage] in
      return Future<Void, CustomError> { promise in
        coreDataStorage.performBackgroundTask { context in
          do {
            try context.save()
            promise(.success(()))
          } catch {
            debugPrint("CoreDataSearchQueriesStorage Unresolved error \(error), \((error as NSError).userInfo)")
            promise(.failure(.genericError))
          }
        }
      }
    }
    .eraseToAnyPublisher()
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
