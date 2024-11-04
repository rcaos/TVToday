//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

public struct NetworkConfig {
  let baseURL: URL
  let headers: [String: String]
  let queryParameters: [String: String]
  
  public init(baseURL: URL, headers: [String : String] = [:], queryParameters: [String : String] = [:]) {
    self.baseURL = baseURL
    self.headers = headers
    self.queryParameters = queryParameters
  }
}
