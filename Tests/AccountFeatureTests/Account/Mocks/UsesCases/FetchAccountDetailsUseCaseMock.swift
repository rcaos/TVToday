//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
import NetworkingInterface
@testable import AccountFeature

final class FetchAccountDetailsUseCaseMock: FetchAccountDetailsUseCase {

  var result: Account?
  var error: DataTransferError?

  func execute() -> AnyPublisher<Account, DataTransferError> {
    if let error = error {
      return Fail(error: error).eraseToAnyPublisher()
    }

    if let result = result {
      return Just(result).setFailureType(to: DataTransferError.self) .eraseToAnyPublisher()
    }

    return Empty().setFailureType(to: DataTransferError.self).eraseToAnyPublisher()
  }

  func execute() async -> AccountFeature.Account? {
    if error != nil {
      return nil
    }

    if let result {
      return result
    } else {
      return nil
    }
  }
}
