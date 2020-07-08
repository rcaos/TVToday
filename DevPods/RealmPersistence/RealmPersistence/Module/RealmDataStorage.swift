//
//  RealmDataStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmDataStorageDelegate: class {
  func persistenceStore(didUpdateEntity update: Bool)
}

public final class RealmDataStorage {
  
  private let maxStorageLimit: Int
  
  private lazy var realm: Realm? = {
    do {
      let realm = try Realm()
      return realm
    } catch let error as NSError {
      return nil
    }
  }()
  
  // MARK: - TODO, refactor
  
  private var notificationToken: NotificationToken?
  weak var delegate: RealmDataStorageDelegate?
  
  // MARK: - Initializer
  
  public init(maxStorageLimit: Int) {
    self.maxStorageLimit = maxStorageLimit
    print(Realm.Configuration.defaultConfiguration.fileURL!)
    objectsDidChange()
  }
  
  // La propia entity debe asignarse sus variables
  // Acá debe llegar un EntityStorage
  public func saveEntitie(entitie: RealmShowVisited, completion: @escaping (() -> Void)) {
    guard let realm = realm else {
      completion()
      return
    }
    do {
      try realm.write {
        realm.add(entitie, update: .modified)
        toDeleted(entitie.userId, retain: maxStorageLimit).forEach {
          print("Delete: \($0) OK")
          realm.delete($0)
        }
        print("Save: \(entitie) OK")
        
        completion()
      }
      
    } catch _ {
      completion()
    }
  }
  
  private func toDeleted(_ userId: Int, retain keepElements: Int) -> [RealmShowVisited] {
    let allElements = fetchAllOrdered(userId: userId)
    let firstElements = allElements.prefix(keepElements)
    return allElements.filter { !firstElements.contains($0) }
  }
  
  public func fetchAllOrdered(userId: Int, ascending: Bool = false) -> [RealmShowVisited] {
    guard let realm = realm else { return [] }
    
    let predicate = NSPredicate(format: "userId = %d", userId)
    return
      realm.objects(RealmShowVisited.self)
    .filter(predicate)
      .sorted(byKeyPath: "date", ascending: ascending).map { $0 }
  }
  
  private func objectsDidChange() {
    let results = realm?.objects(RealmShowVisited.self)
    notificationToken = results?.observe { [weak self] (changes: RealmCollectionChange) in
      switch changes {
      case .update:
        self?.delegate?.persistenceStore(didUpdateEntity: true)
      default:
        break
      }
    }
  }
  
  // For Searchs.
  public func saveQuery(entitie: RealmSearchShow, completion: @escaping (() -> Void)) {
    guard let realm = realm else {
      completion()
      return
    }
    do {
      try realm.write {
        realm.add(entitie, update: .modified)
        print("Save Search: \(entitie) OK")
        completion()
      }
      
    } catch _ {
      completion()
    }
  }
  
  public func fetchAllSearchs(for userId: Int) -> [RealmSearchShow] {
    guard let realm = realm else { return [] }
    let predicate = NSPredicate(format: "userId = %d", userId)
    
    return realm.objects(RealmSearchShow.self)
      .filter(predicate)
      .sorted(byKeyPath: "date", ascending: false).map { $0 }
  }
}
