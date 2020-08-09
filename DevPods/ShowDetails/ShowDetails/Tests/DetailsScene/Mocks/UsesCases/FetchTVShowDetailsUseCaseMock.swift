//
//  FetchTVShowDetailsUseCaseMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import RxSwift
@testable import ShowDetails
@testable import Shared

class FetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCase {
  
  typealias Response = Result<TVShowDetailResult, Error>
  
  var error: Error?
  var result: TVShowDetailResult?
  
  func execute(requestValue: FetchTVShowDetailsUseCaseRequestValue) -> Observable<Response> {
    if let error = error {
      print("--ask for Error")
      return Observable.just( .failure(error) )
    }
    
    if let result = result {
      print("--ask for Result")
      return Observable.just( .success(result) )
    }
    
    return Observable.empty()
  }
}
