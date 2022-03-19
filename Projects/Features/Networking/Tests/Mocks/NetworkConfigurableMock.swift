//
//  NetworkConfigurableMock.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation
@testable import NetworkingInterface

class NetworkConfigurableMock: NetworkConfigurable {
  var baseURL: URL = URL(string: "https://mock.test.com")!
  var headers: [String: String] = [:]
  var queryParameters: [String: String] = [:]
}
