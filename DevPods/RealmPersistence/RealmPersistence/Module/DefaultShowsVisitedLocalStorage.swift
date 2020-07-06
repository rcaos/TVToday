//
//  DefaultShowsVisitedLocalStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 7/2/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift
import RealmSwift
import Persistence

public final class DefaultShowsVisitedLocalStorage {
  
  private let realmDataStack: RealmDataStorage
  
  private let showsVisitedSubject = BehaviorSubject<[ShowVisited]>(value: [])
  
  public init(realmDataStack: RealmDataStorage) {
    self.realmDataStack = realmDataStack
    self.realmDataStack.delegate = self
  }
}

extension DefaultShowsVisitedLocalStorage: ShowsVisitedLocalStorage {
  
  public func saveShow(id: Int, pathImage: String, userId: Int) -> Observable<Void> {
    
    return Observable<()>.create { [weak self] (event) -> Disposable in
      let disposable = Disposables.create()

      let persistEntitie = RealmShowVisited()
      persistEntitie.id = id
      persistEntitie.userId = userId
      persistEntitie.pathImage = pathImage

      self?.realmDataStack.saveEntitie(entitie: persistEntitie) {
        event.onNext(())
        event.onCompleted()
      }
      return disposable
    }
  }
  
  public func fetchVisitedShows() -> Observable<[ShowVisited]> {
    showsVisitedSubject.onNext( fetchVisitedShowList() )
    return showsVisitedSubject.asObservable()
  }
  
  fileprivate func fetchVisitedShowList() -> [ShowVisited] {
    return realmDataStack.fetchAllOrdered().map { $0.asDomain() }
  }
}

// MARK: - RealmDataStorageDelegate

extension DefaultShowsVisitedLocalStorage: RealmDataStorageDelegate {
  
  func persistenceStore(didUpdateEntity update: Bool) {
    showsVisitedSubject.onNext( fetchVisitedShowList() )
  }
}
