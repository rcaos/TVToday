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

extension CoreDataSearchQueriesStorage: SearchLocalDataSource {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [store] in
      return Future<Void, CustomError> { promise in
        store.delete(query: query)
        store.insert(query: query, userId: userId)
        promise(.success(()))
      }
    }
    .eraseToAnyPublisher()
  }

  public func fetchRecentSearches(userId: Int) -> AnyPublisher<[SearchDLO], CustomError> {
    return Deferred { [store] in
      return Future<[SearchDLO], CustomError> { promise in
        let results = store.findAll(userId: userId).map { $0.toDomain() }
        promise(.success(results))
      }
    }
    .eraseToAnyPublisher()
  }
}
