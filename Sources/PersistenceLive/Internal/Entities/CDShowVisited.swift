//
//  CDShowVisited.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//

import CoreData
import Persistence

final class CDShowVisited: NSManagedObject {

  @NSManaged private(set) var id: Int
  @NSManaged private(set) var createdAt: Date
  @NSManaged private(set) var pathImage: String
  @NSManaged private(set) var userId: Int

  static func insert(into context: NSManagedObjectContext, showId: Int, pathImage: String, userId: Int) -> CDShowVisited {
    let showVisited: CDShowVisited = context.insertObject()
    showVisited.id = showId
    showVisited.createdAt = Date()
    showVisited.pathImage = pathImage
    showVisited.userId = userId
    return showVisited
  }
}

extension CDShowVisited {
  func toDomain() -> ShowVisitedDLO {
    return ShowVisitedDLO(id: id, pathImage: pathImage)
  }
}

extension CDShowVisited: Managed {
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(createdAt), ascending: false)]
  }
}
