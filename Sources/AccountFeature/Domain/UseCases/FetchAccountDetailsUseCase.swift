//
//  Created by Jeans Ruiz on 6/21/20.
//

import Foundation

protocol FetchAccountDetailsUseCase {
  func execute() async -> Account?
}

final class DefaultFetchAccountDetailsUseCase: FetchAccountDetailsUseCase {
  private let accountRepository: AccountRepository

  init(accountRepository: AccountRepository) {
    self.accountRepository = accountRepository
  }

  func execute() async -> Account? {
    return await accountRepository.getAccountDetails()
  }
}
