//
//  AccessTokenRepository.swift
//  
//
//  Created by Jeans Ruiz on 12/05/22.
//

import Foundation

public final class AccessTokenRepository {
  private let dataSource: AccessTokenLocalDataSource

  public init(dataSource: AccessTokenLocalDataSource) {
    self.dataSource = dataSource
  }
}

extension AccessTokenRepository: AccessTokenRepositoryProtocol {
  public func saveAccessToken(_ token: String) {
    dataSource.saveAccessToken(token)
  }

  public func getAccessToken() -> String {
    dataSource.getAccessToken()
  }
}
