//
//  DefaultSearchLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import RealmSwift
import Persistence
import Shared

public final class DefaultSearchLocalStorage {
  private let store: PersistenceStore<RealmSearchShow>

  public init(realmDataStack: RealmDataStorage) {
    self.store = PersistenceStore(realmDataStack.realm)
  }
}

extension DefaultSearchLocalStorage: SearchLocalStorage {

  public func saveSearch(query: String, userId: Int) -> AnyPublisher<Void, CustomError> {
    return Deferred { [store] in
      return Future<Void, CustomError> { [store] promise in
        let persistEntity = RealmSearchShow()
        persistEntity.query = query
        persistEntity.userId = userId

        store.saveSearch(entitie: persistEntity) {
          promise(.success(()))
        }
      }
    }
    .eraseToAnyPublisher()
  }

  public func fetchSearchs(userId: Int) -> AnyPublisher<[Search], CustomError> {
    return Just(
      store.find(for: userId).map { $0.asDomain() }
    )
      .setFailureType(to: CustomError.self)
      .eraseToAnyPublisher()
  }
}
