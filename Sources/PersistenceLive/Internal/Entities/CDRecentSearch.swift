//
//  CDRecentSearch.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/6/20.
//

import CoreData
import Persistence

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

extension CDRecentSearch {
  func toDomain() -> Search {
    return Search(query: query)
  }
}

extension CDRecentSearch: Managed {
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
  }
}
