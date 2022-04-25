//
//  CDShowVisited.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//

import CoreData

final class CDShowVisited: NSManagedObject {

  @NSManaged private(set) var id: String
  @NSManaged private(set) var createdAt: Date
  @NSManaged private(set) var pathImage: String
  @NSManaged private(set) var userId: Int

  static func insert(into context: NSManagedObjectContext, pathImage: String, userId: Int) -> CDShowVisited {
    let showVisited: CDShowVisited = context.insertObject()
    showVisited.id = UUID().uuidString
    showVisited.createdAt = Date()
    showVisited.pathImage = pathImage
    showVisited.userId = userId
    return showVisited
  }
}
