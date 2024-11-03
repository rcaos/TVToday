//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
import NetworkingInterface
@testable import AccountFeature

final class FetchAccountDetailsUseCaseMock: FetchAccountDetailsUseCase {

  var result: Account?
  var error: ApiError?

  func execute() async -> Account? {
    if error != nil {
      return nil
    }
    return result
  }
}
