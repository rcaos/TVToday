//
//  Created by Jeans Ruiz on 8/4/20.
//

import Foundation
import Combine
import NetworkingInterface
@testable import ShowDetailsFeature
@testable import Shared

class SaveToWatchListUseCaseMock: SaveToWatchListUseCase {
  //let subject = PassthroughSubject<Bool, DataTransferError>()
  var result: Bool?
  var error: ApiError?
  var calledCounter = 0

  public func execute(request: SaveToWatchListUseCaseRequestValue) async throws -> Bool {
    calledCounter += 1

    if let error = error {
      throw error
    }

    if let result = result {
      return result
    } else {
      throw ApiError(error: NSError(domain: "Mock", code: 0, userInfo: nil))
    }
  }
}
