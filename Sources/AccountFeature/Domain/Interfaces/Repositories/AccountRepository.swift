//
//  Created by Jeans Ruiz on 6/21/20.
//

import Combine
import NetworkingInterface

public protocol AccountRepository {
  func getAccountDetails() -> AnyPublisher<Account, DataTransferError>
  func getAccountDetails() async -> Account?
}
