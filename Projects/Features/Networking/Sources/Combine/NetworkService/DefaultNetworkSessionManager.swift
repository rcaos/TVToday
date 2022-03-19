//
//  DefaultNetworkSessionManager.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
import NetworkingInterface
import Combine

// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be injected into NetworkService instead of default one.

public class DefaultNetworkSessionManager: NetworkSessionManager {

  public init() {}

  public func request(_ request: URLRequest) -> AnyPublisher<NetworkingOutput, URLError> {
    return URLSession.shared.dataTaskPublisher(for: request).eraseToAnyPublisher()
  }
}
