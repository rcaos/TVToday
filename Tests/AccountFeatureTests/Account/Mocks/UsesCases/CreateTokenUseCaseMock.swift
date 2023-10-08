//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Combine
import NetworkingInterface
@testable import AccountFeature

final class CreateTokenUseCaseMock: CreateTokenUseCase {

  var result: URL?
  var error: DataTransferError?

  func execute() -> AnyPublisher<URL, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self) .eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }

  func execute() async -> URL? {
    if error != nil {
      return nil
    }

    return result
  }
}
