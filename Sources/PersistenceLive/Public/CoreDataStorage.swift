//
//  CoreDataStorage.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

public final class CoreDataStorage {

  public static let shared = CoreDataStorage()

  private init() { }

  lazy var persistentContainer: NSPersistentContainer = {
    guard let modelURL = Bundle.module.url(forResource: "CoreDataStorage", withExtension: "momd"),
          let objectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("CoreDataStorage cannot found resource")
          }

    let container = NSPersistentContainer(name: "CoreDataStorage", managedObjectModel: objectModel)

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()
}
