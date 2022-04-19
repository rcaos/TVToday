//
//  RealmSearchShow.swift
//  RealmPersistence
//
//  Created by Jeans Ruiz on 7/6/20.
//

import Foundation
import RealmSwift
import Persistence

public class RealmSearchShow: Object {
  @objc dynamic var query = ""

  @objc dynamic var date = Date()

  @objc dynamic var userId = 0

  public override static func primaryKey() -> String? {
    return "query"
  }

  public func asDomain() -> Search {
    return Search(query: query)
  }
}
