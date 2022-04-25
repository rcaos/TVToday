//
//  CoreDataStorage.swift
//  PersistenceLive
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import CoreData

// MARK: - TODO, should below to Persistence
enum CoreDataStorageError: Error {
  case readError(Error)
  case saveError(Error)
  case deleteError(Error)
}

final class CoreDataStorage {

  static let shared = CoreDataStorage()

  private init() {}

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "CoreDataStorage")
    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
      }
    }
    return container
  }()

  // MARK: - Core Data Saving support
//  func saveContext() {
//    let context = persistentContainer.viewContext
//    if context.hasChanges {
//      do {
//        try context.save()
//      } catch {
//        assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
//      }
//    }
//  }

  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask(block)
  }
}
