//
//  CDRecentSearch.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/6/20.
//

import CoreData

final class CDRecentSearch: NSManagedObject {

  @NSManaged private(set) var id: String
  @NSManaged private(set) var query: String
  @NSManaged private(set) var createdAt: Date
  @NSManaged private(set) var userId: Int

  static func insert(into context: NSManagedObjectContext, query: String, userId: Int) -> CDRecentSearch {
    let recentSearch: CDRecentSearch = context.insertObject()
    recentSearch.id = UUID().uuidString
    recentSearch.query = query
    recentSearch.userId = userId
    recentSearch.createdAt = Date()
    return recentSearch
  }
}

// MARK: -  Move to Helper
extension NSManagedObjectContext {

//  func insertObject<A: NSManagedObject>() -> A where A: Managed {
  func insertObject<A: NSManagedObject>() -> A {
    guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
      fatalError("Wrong object type")
    }
    return obj
  }
}


extension NSManagedObject {
  static var entityName: String {
    return entity().name!
  }
}
