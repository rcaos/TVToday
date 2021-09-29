//
//  FetchEpisodesUseCase+Mock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/6/20.
//

import RxSwift
@testable import ShowDetails

final class FetchEpisodesUseCaseMock: FetchEpisodesUseCase {
  
  var error: Error?
  
  var result: SeasonResult?
  
  func execute(requestValue: FetchEpisodesUseCaseRequestValue) -> Observable<SeasonResult> {
    if let error = error {
      return Observable.error(error)
    }
    
    if let result = result {
      return Observable.just(result)
    }
    
    return Observable.empty()
  }
}
