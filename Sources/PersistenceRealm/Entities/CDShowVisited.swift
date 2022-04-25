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

  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDShowVisited> {
    return NSFetchRequest<CDShowVisited>(entityName: "CDShowVisited")
  }
}

extension CDShowVisited {
  func toDomain() -> ShowVisited {
    return ShowVisited(id: id, pathImage: pathImage)
  }
}
