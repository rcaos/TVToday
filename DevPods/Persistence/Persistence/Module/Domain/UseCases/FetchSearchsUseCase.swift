//
//  FetchSearchsUseCase.swift
//  Persistence
//
//  Created by Jeans Ruiz on 7/7/20.
//

import RxSwift
import Shared

public protocol FetchSearchsUseCase {
  
  func execute(requestValue: FetchSearchsUseCaseRequestValue) -> Observable<[Search]>
}

public struct FetchSearchsUseCaseRequestValue {
  public init() { }
}

public final class DefaultFetchSearchsUseCase: FetchSearchsUseCase {
  
  private let searchLocalRepository: SearchLocalRepository
  private let keychainRepository: KeychainRepository
  
  public init(searchLocalRepository: SearchLocalRepository,
              keychainRepository: KeychainRepository) {
    self.searchLocalRepository = searchLocalRepository
    self.keychainRepository = keychainRepository
  }
  
  public func execute(requestValue: FetchSearchsUseCaseRequestValue) -> Observable<[Search]> {
    
    var idLogged = 0
    if let userLogged = keychainRepository.fetchLoguedUser() {
      idLogged = userLogged.id
    }
    
    return searchLocalRepository.fetchSearchs(userId: idLogged)
  }
}
