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
    self.store.configureResultsController(
      sortDescriptors: [NSSortDescriptor(key: #keyPath(CDShowVisited.createdAt), ascending: false)]
    )
    self.store.delegate = self
  }
}

extension CoreDataShowVisitedStorage: ShowsVisitedLocalRepository {

  public func saveShow(id: Int, pathImage: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [store] in
      return Future<Void, CustomError> { promise in
        store.managedObjectContext.perform {
          do {
            let context = store.managedObjectContext

            // Remove first
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDShowVisited.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K = %i", #keyPath(CDShowVisited.id), id)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(deleteRequest)

            // Save visit
            _ = CDShowVisited.insert(into: context, showId: id, pathImage: pathImage, userId: userId)
            try context.save()
            promise(.success(()))
          } catch {
            debugPrint("CoreDataShowVisitedStorage Unresolved error \(error), \((error as NSError).userInfo)")
            promise(.failure(.genericError))
          }
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func fetchVisitedShows(userId: Int) -> AnyPublisher<[ShowVisited], CustomError> {
    return Deferred { [store] in
      return Future<[ShowVisited], CustomError> { promise in
        store.managedObjectContext.perform {
          do {
            let request: NSFetchRequest = CDShowVisited.fetchRequest()
            request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDShowVisited.userId), userId)
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CDShowVisited.createdAt), ascending: false)]

            let results = try store.managedObjectContext.fetch(request).map { $0.toDomain() }
            promise(.success(results))
          } catch {
            debugPrint("CoreDataShowVisitedStorage Unresolved error \(error), \((error as NSError).userInfo)")
            promise(.failure(.genericError))
          }
        }
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
