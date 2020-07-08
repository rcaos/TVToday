//
//  RealmShowVisited.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/2/20.
//

import Foundation
import RealmSwift
import Persistence

public class RealmShowVisited: Object {
  
  @objc dynamic var id = 0
  
  @objc dynamic var pathImage = ""
  
  @objc dynamic var userId = 0
  
  @objc dynamic var date = Date()
  
  public override static func primaryKey() -> String? {
    return "id"
  }
  
  public func asDomain() -> ShowVisited {
    return ShowVisited(id: id, pathImage: pathImage)
  }
}
