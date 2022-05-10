//
//  DefaultAuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import Foundation
import NetworkingInterface
import Networking
import Shared

final class DefaultAuthRepository {
  private let remoteDataSource: AuthRemoteDataSource
  private let requestTokenRepository: RequestTokenRepository
  private let accessTokenRepository: AccessTokenRepository

  init(remoteDataSource: AuthRemoteDataSource,
       requestTokenRepository: RequestTokenRepository,
       accessTokenRepository: AccessTokenRepository) {
    self.remoteDataSource = remoteDataSource
    self.requestTokenRepository = requestTokenRepository
    self.accessTokenRepository = accessTokenRepository
  }
}

// MARK: - AuthRepository
extension DefaultAuthRepository: AuthRepository {


  func requestToken() -> AnyPublisher<NewRequestToken, DataTransferError> {
    return remoteDataSource.requestToken()
      .tryMap { result -> NewRequestToken in
        // MARK: - TODO, Inject URL base instead
        let newToken = try self.mapRequestToken(basePath: "https://www.themoviedb.org/authenticate", result: result)
        self.requestTokenRepository.saveRequestToken (result.token)
        return newToken
      }
      .mapError { error -> DataTransferError in
        return DataTransferError.noResponse // MARk: - TODO, change error
      }
      .eraseToAnyPublisher()
  }

  // MARK: - TODO, move to Mapping file
  private func mapRequestToken(basePath: String, result: NewRequestTokenDTO) throws -> NewRequestToken {
    if result.success == true,
       let url = URL(string: "\(basePath)/\(result.token)") {
      return NewRequestToken(token: result.token, url: url)
    } else {
      print("cannot Convert request token= \(result), basePath=\(basePath)")
      throw DataTransferError.noResponse // MARk: - TODO, change error
    }
  }

  func createSession() -> AnyPublisher<NewSession, DataTransferError> {
    guard let requestToken = requestTokenRepository.getRequestToken() else {
      return Fail(error: DataTransferError.noResponse).eraseToAnyPublisher()
    }
    return remoteDataSource.createSession(requestToken: requestToken)
      .map {
        self.accessTokenRepository.saveAccessToken($0.sessionId)
        return NewSession(success: $0.success, sessionId: $0.sessionId)
      }
      .eraseToAnyPublisher()
  }
}
