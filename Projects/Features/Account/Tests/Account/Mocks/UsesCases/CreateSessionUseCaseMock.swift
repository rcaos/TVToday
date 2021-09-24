//
//  CreateSessionUseCaseMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import AccountTV

final class CreateSessionUseCaseMock: CreateSessionUseCase {
  
  var result: Void?
  
  var error: Error?
  
  func execute() -> Observable<Void> {
    if let error = error {
      return Observable.error(error)
    }
    
    if let result = result {
      return Observable.just(result)
    }
    
    return Observable.empty()
  }
}
