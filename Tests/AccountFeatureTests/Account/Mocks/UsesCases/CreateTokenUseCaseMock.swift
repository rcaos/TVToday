//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Combine
import NetworkingInterface
@testable import AccountFeature

final class CreateTokenUseCaseMock: CreateTokenUseCase {

  var result: URL?
  var error: ApiError?

  func execute() async -> URL? {
    if let error = error {
      return nil
    }
    return result
  }
}
