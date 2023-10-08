//
//  Created by Jeans Ruiz on 11/08/23.
//

import Foundation

public struct NetworkLogger {
  let logRequest: (URLRequest) -> Void
  let logResponse: (Data, URLResponse) -> Void
  let logError: (Error) -> Void

  public init(
    logRequest: @escaping (URLRequest) -> Void,
    logResponse: @escaping (Data, URLResponse) -> Void,
    logError: @escaping (Error) -> Void
  ) {
    self.logRequest = logRequest
    self.logResponse = logResponse
    self.logError = logError
  }
}
