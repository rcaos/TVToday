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

  // MARK: - Private
  private func find(for userId: Int) -> NSFetchRequest<CDRecentSearch> {
    let request: NSFetchRequest = CDRecentSearch.fetchRequest()
    // MARK: - TODO, .sorted(byKeyPath: "date", ascending: false).map { $0 }
    request.predicate = NSPredicate(format: "%K = %d",
                                    #keyPath(CDRecentSearch.userId), userId)
    return request
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
    return Deferred { [coreDataStorage] in
      return Future<[Search], CustomError> { promise in
        coreDataStorage.performBackgroundTask { context in
          do {
            let fetchRequest = self.find(for: userId)
            let results = try context.fetch(fetchRequest)
            let domain = results.map { $0.toDomain() }
            promise(.success(domain))
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
