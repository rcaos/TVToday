//
//  CDRecentSearch+PersistenceStore.swift
//  
//
//  Created by Jeans Ruiz on 26/04/22.
//

import CoreData

extension PersistenceStore where Entity == CDRecentSearch {
  
  func delete(query: String) {
    do {
      let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CDRecentSearch.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "%K = %@", #keyPath(CDRecentSearch.query), query)
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
      try self.managedObjectContext.execute(deleteRequest)
    } catch { }
  }
  
  func insert(query: String, userId: Int) {
    managedObjectContext.performChanges { [managedObjectContext] in
      _ = CDRecentSearch.insert(into: managedObjectContext, query: query, userId: userId)
    }
  }
  
  func findAll(userId: Int) -> [CDRecentSearch] {
    return CDRecentSearch.fetch(in: managedObjectContext, configurationBlock: { request in
      request.predicate = NSPredicate(format: "%K = %d", #keyPath(CDRecentSearch.userId), userId)
    })
  }
}
