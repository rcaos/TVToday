//
//  DefaultAuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
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
