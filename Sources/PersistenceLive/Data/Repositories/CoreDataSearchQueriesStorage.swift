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

final class CoreDataSearchQueriesStorage {
  private let store: PersistenceStore<CDRecentSearch>

  public init(store: PersistenceStore<CDRecentSearch>) {
    self.store = store
  }
}

extension CoreDataSearchQueriesStorage: SearchLocalRepository {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [store] in
      return Future<Void, CustomError> { promise in
        store.managedObjectContext.perform {
          let context = store.managedObjectContext

          do {
            // Remove first
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDRecentSearch.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(CDRecentSearch.query), query)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)

            // Save recent search
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
    return Deferred { [store] in
      return Future<[Search], CustomError> { promise in
        store.managedObjectContext.perform {
          do {
            let request: NSFetchRequest = CDRecentSearch.fetchRequest()
            request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDRecentSearch.userId), userId)
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDRecentSearch.createdAt), ascending: false)]

            let results = try store.managedObjectContext.fetch(request).map { $0.toDomain() }
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
