//
//  PersistenceStore.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/8/20.
//

import Foundation
import RealmSwift

protocol PersistenceStoreDelegate: AnyObject {
  func persistenceStore(didUpdateEntity update: Bool)
}

class PersistenceStore<Entity: Object> {

  weak var delegate: PersistenceStoreDelegate?

  let realm: Realm?

  let maxStorageLimit: Int

  private var notificationToken: NotificationToken?

  // MARK: - Initializer
  init(_ realm: Realm?, maxStorageLimit: Int = 10) {
    self.realm = realm
    self.maxStorageLimit = maxStorageLimit
  }

  func subscribeToChanges() {
    let results = realm?.objects(Entity.self)
    notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
      switch changes {
      case .update:
        self?.delegate?.persistenceStore(didUpdateEntity: true)
      default:
        break
      }
    }
  }
}
