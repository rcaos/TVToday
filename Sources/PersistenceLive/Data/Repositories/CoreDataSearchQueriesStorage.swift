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
            _ = CDRecentSearch.insert(into: context, query: query, userId: userId)
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
    return Deferred { [coreDataStorage] in
      return Future<[Search], CustomError> { promise in
        coreDataStorage.performBackgroundTask { context in
          do {
            let request: NSFetchRequest = CDRecentSearch.fetchRequest()
            // MARK: - TODO, .sorted(byKeyPath: "date", ascending: false).map { $0 }
            request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDRecentSearch.userId), userId)

            let results = try context.fetch(request).map { $0.toDomain() }
            promise(.success(results))
          } catch {
            debugPrint("CoreDataSearchQueriesStorage Unresolved error \(error), \((error as NSError).userInfo)")
            promise(.failure(.genericError))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }
}
