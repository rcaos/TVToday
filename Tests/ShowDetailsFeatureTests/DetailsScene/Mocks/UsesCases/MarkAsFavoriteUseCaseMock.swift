//
//  Created by Jeans Ruiz on 8/4/20.
//

import Foundation
import Combine
import NetworkingInterface
import ShowDetailsFeature
import Shared

class MarkAsFavoriteUseCaseMock: MarkAsFavoriteUseCase {
  //let subject = PassthroughSubject<Bool, DataTransferError>()
  var result: Bool?
  var error: ApiError?
  var calledCounter = 0

  public func execute(request: MarkAsFavoriteUseCaseRequestValue) async throws -> Bool {
    calledCounter += 1

    if let error = error {
      throw error
    }

    if let result = result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "MockError", code: 0, userInfo: nil))
    }
  }
}
