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
  private let requestTokenRepository: RequestTokenRepositoryProtocol
  private let accessTokenRepository: AccessTokenRepositoryProtocol
  private let tokenMapper: RequestTokenMapperProtocol

  init(remoteDataSource: AuthRemoteDataSource,
       requestTokenRepository: RequestTokenRepositoryProtocol,
       accessTokenRepository: AccessTokenRepositoryProtocol,
       tokenMapper: RequestTokenMapperProtocol) {
    self.remoteDataSource = remoteDataSource
    self.requestTokenRepository = requestTokenRepository
    self.accessTokenRepository = accessTokenRepository
    self.tokenMapper = tokenMapper
  }
}

// MARK: - AuthRepository
extension DefaultAuthRepository: AuthRepository {

  func requestToken() -> AnyPublisher<NewRequestToken, DataTransferError> {
    return remoteDataSource.requestToken()
      .tryMap { result -> NewRequestToken in
        let newToken = try self.tokenMapper.mapRequestToken(model: result)
        self.requestTokenRepository.saveRequestToken (result.token)
        return newToken
      }
      .mapError { error -> DataTransferError in
        return DataTransferError.noResponse // MARk: - TODO, change error
      }
      .eraseToAnyPublisher()
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

  func requestToken() async -> NewRequestToken? {
    do {
      let dto = try await remoteDataSource.requestToken()
      let tokenModel = try tokenMapper.mapRequestToken(model: dto)
      requestTokenRepository.saveRequestToken(tokenModel.token)
      return tokenModel
    } catch {
      #warning("todo: log error")
      return nil
    }
  }

  func createSession() async -> NewSession? {
    guard let requestToken = requestTokenRepository.getRequestToken() else {
      return nil
    }

    do {
      let dto = try await remoteDataSource.createSession(requestToken: requestToken)
      accessTokenRepository.saveAccessToken(dto.sessionId)
      return NewSession(success: dto.success, sessionId: dto.sessionId)
    } catch {
      #warning("todo: log")
      return nil
    }
  }
}
