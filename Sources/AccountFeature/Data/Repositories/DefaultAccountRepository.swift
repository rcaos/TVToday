//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Shared

public final class DefaultAccountRepository {
  private let remoteDataSource: AccountRemoteDataSource
  private let accessTokenRepository: AccessTokenRepositoryProtocol
  private let userLoggedRepository: LoggedUserRepositoryProtocol
  private let gravatarBaseURL: String

  init(remoteDataSource: AccountRemoteDataSource, accessTokenRepository: AccessTokenRepositoryProtocol,
       userLoggedRepository: LoggedUserRepositoryProtocol,
       gravatarBaseURL: String) {
    self.remoteDataSource = remoteDataSource
    self.accessTokenRepository = accessTokenRepository
    self.userLoggedRepository = userLoggedRepository
    self.gravatarBaseURL = gravatarBaseURL
  }
}

// MARK: - AccountRepository
extension DefaultAccountRepository: AccountRepository {

  public func getAccountDetails() async -> Account? {
    do {
      let sessionId = accessTokenRepository.getAccessToken()
      let dto = try await remoteDataSource.getAccountDetails(session: sessionId)

      let avatarURL = URL(string: "\(self.gravatarBaseURL)/\(dto.avatar?.gravatar?.hash ?? "" )")
      return Account(id: dto.id, userName: dto.userName, avatarURL: avatarURL)
    } catch  {
      #warning("todo: log")
      return nil
    }
  }
}
