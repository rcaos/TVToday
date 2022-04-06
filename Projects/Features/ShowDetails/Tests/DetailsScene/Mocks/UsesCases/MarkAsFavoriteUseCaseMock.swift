//
//  MarkAsFavoriteUseCaseMock.swift
//  ShowDetails-Unit-Tests
//
//  Created by Jeans Ruiz on 8/4/20.
//

import Combine
import NetworkingInterface
import ShowDetails
import Shared

class MarkAsFavoriteUseCaseMock: MarkAsFavoriteUseCase {
  let subject = PassthroughSubject<Bool, DataTransferError>()
  var result: Bool?
  var error: DataTransferError?
  var calledCounter = 0
  
  func execute(requestValue: MarkAsFavoriteUseCaseRequestValue) -> AnyPublisher<Bool, DataTransferError> {
    calledCounter += 1
    
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }
    
    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
    }
    
    return subject.eraseToAnyPublisher()
  }
}
