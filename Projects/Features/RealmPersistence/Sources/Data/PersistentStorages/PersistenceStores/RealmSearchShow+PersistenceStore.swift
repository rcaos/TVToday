//
//  RealmSearchShow+PersistenceStore.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/8/20.
//

import Foundation
import RealmSwift

extension PersistenceStore where Entity == RealmSearchShow {
  
  func saveSearch(entitie: Entity, completion: @escaping(() -> Void)) {
    guard let realm = realm else {
      completion()
      return
    }
    do {
      try realm.write {
        realm.add(entitie, update: .modified)
        //print("Save Search: \(entitie) OK")
        completion()
      }
      
    } catch _ {
      completion()
    }
  }
  
  func find(for userId: Int) -> [Entity] {
    guard let realm = realm else { return [] }
    let predicate = NSPredicate(format: "userId = %d", userId)
    
    return realm.objects(Entity.self)
      .filter(predicate)
      .sorted(byKeyPath: "date", ascending: false).map { $0 }
  }
}
