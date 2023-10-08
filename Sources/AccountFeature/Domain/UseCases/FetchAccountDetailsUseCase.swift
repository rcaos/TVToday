//
//  Created by Jeans Ruiz on 6/21/20.
//

import Combine
import Shared
import NetworkingInterface

protocol FetchAccountDetailsUseCase {
  func execute() -> AnyPublisher<Account, DataTransferError>
  func execute() async -> Account?
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  private let accountRepository: AccountRepository

  init(accountRepository: AccountRepository) {
    self.accountRepository = accountRepository
  }

  func execute() -> AnyPublisher<Account, DataTransferError> {
    return accountRepository.getAccountDetails()
  }

  func execute() async -> Account? {
    return await accountRepository.getAccountDetails()
  }
}
