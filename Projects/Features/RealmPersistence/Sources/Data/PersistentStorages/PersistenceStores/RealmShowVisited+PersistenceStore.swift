//
//  RealmShowVisited+PersistenceStore.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/8/20.
//

import Foundation
import RealmSwift

extension PersistenceStore where Entity == RealmShowVisited {

  func find(for userId: Int, ascending: Bool = false) -> [Entity] {
    guard let realm = realm else {
      return []
    }

    let predicate = NSPredicate(format: "userId = %d", userId)

    return realm.objects(Entity.self)
      .filter(predicate)
      .sorted(byKeyPath: "date", ascending: ascending).map { $0 }
  }

  func saveVisit(entity: Entity, completion: @escaping(() -> Void)) {
    guard let realm = realm else {
      completion()
      return
    }

    do {
      try realm.write {
        realm.add(entity, update: .modified)
        toDeleted(entity.userId, keepElements: maxStorageLimit).forEach {
          print("Delete: \($0) OK")
          realm.delete($0)
        }
        print("Save: \(entity) OK")

        completion()
      }
    } catch _ {
      completion()
    }
  }

  // MARK: - Private
  private func toDeleted(_ userId: Int, keepElements: Int) -> [Entity] {
    let allElements = find(for: userId)
    let firstElements = allElements.prefix(keepElements)
    return allElements.filter { !firstElements.contains($0) }
  }
}
