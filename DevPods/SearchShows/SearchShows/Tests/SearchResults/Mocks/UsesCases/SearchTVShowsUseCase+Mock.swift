//
//  FetchGenresUseCase+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import SearchShows
@testable import Shared

final class SearchTVShowsUseCaseMock: SearchTVShowsUseCase {
  
  var error: Error?
  
  var result: TVShowResult?
  
  func execute(requestValue: SearchTVShowsUseCaseRequestValue) -> Observable<TVShowResult> {
    if let error = error {
      return Observable.error(error)
    }
    
    if let result = result {
      return Observable.just(result)
    }
    
    return Observable.empty()
  }
}
