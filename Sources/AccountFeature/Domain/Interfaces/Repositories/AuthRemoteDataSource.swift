//
//  AuthRemoteDataSource.swift
//  
//
//  Created by Jeans Ruiz on 7/05/22.
//

import Combine
import NetworkingInterface

protocol AuthRemoteDataSource {
  func requestToken() -> AnyPublisher<NewRequestTokenDTO, DataTransferError>
  func createSession(requestToken: String) -> AnyPublisher<NewSessionDTO, DataTransferError>
}
