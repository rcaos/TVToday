//
//  FetchGenresUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import SearchShows

final class FetchGenresUseCaseMock: FetchGenresUseCase {
  
  var error: Error?
  
  var result: GenreListResult?
  
  func execute(requestValue: FetchGenresUseCaseRequestValue) -> Observable<GenreListResult> {
    if let error = error {
      return Observable.error(error)
    }
    
    if let result = result {
      return Observable.just(result)
    }
    
    return Observable.empty()
  }
}
