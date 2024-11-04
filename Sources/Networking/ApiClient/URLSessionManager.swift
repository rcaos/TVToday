//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

public struct URLSessionManager {
  let request: (URLRequest) async throws -> (Data, URLResponse)

  public init(request: @escaping (URLRequest) async throws -> (Data, URLResponse)) {
    self.request = request
  }
}

extension URLSessionManager {
  public static var live: URLSessionManager = {
    return URLSessionManager(request: {
      return try await URLSession.shared.data(for: $0)
    })
  }()
}
