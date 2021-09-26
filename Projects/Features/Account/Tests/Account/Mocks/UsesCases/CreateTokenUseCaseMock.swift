//
//  CreateTokenUseCaseMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import Account

final class CreateTokenUseCaseMock: CreateTokenUseCase {
  
  var error: Error?
  
  var result: URL?
  
  func execute() -> Observable<URL> {
    
    if let error = error {
      return Observable.error(error)
    }
    
    if let result = result {
      return Observable.just(result)
    }
    
    return Observable.empty()
  }
}
