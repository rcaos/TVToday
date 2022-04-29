//
//  CDShowVisited+PersistenceStore.swift
//  
//
//  Created by Jeans Ruiz on 26/04/22.
//

import CoreData

extension PersistenceStore where Entity == CDShowVisited {

  func delete(showId: Int) {
    managedObjectContext.performChanges { [managedObjectContext] in
      do {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDShowVisited.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %i", #keyPath(CDShowVisited.id), showId)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try managedObjectContext.execute(deleteRequest)
      } catch { }
    }
  }

  func insert(id: Int, pathImage: String, userId: Int) {
    managedObjectContext.performChanges { [managedObjectContext] in
      _ = CDShowVisited.insert(into: managedObjectContext, showId: id, pathImage: pathImage, userId: userId)
    }
  }

  func findAll(for userId: Int) -> [CDShowVisited] {
    return CDShowVisited.fetch(in: managedObjectContext, configurationBlock: { fetchRequest in
      fetchRequest.predicate = NSPredicate(format: "%K = %d", #keyPath(CDShowVisited.userId), userId)
    })
  }

  func deleteLimitStorage(userId: Int, until limit: Int) {
    managedObjectContext.performChanges { [managedObjectContext] in
      do {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDShowVisited.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %i", #keyPath(CDShowVisited.userId), userId)
        fetchRequest.sortDescriptors = CDShowVisited.defaultSortDescriptors
        fetchRequest.fetchOffset = (limit > 0) ? limit - 1 : 0
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try managedObjectContext.execute(deleteRequest)
      } catch { }
    }
  }
}
