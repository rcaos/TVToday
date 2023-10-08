//
//  AuthRepository.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

protocol AuthRepository {
  func requestToken() -> AnyPublisher<NewRequestToken, DataTransferError>
  func createSession() -> AnyPublisher<NewSession, DataTransferError>

  func requestToken() async -> NewRequestToken?
  func createSession() async -> NewSession?
}
