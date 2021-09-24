//
//  RealmDataStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmDataStorage {
  
  lazy var realm: Realm? = {
    do {
      let realm = try Realm()
      return realm
    } catch let error as NSError {
      return nil
    }
  }()
  
  // MARK: - Initializer
  
  public init() {
    //print(Realm.Configuration.defaultConfiguration.fileURL!)
  }
}
