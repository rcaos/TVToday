//
//  Created by Jeans Ruiz on 19/03/22.
//

import Foundation

#warning("TODO: Unify with ApiError")
public enum NetworkError: Error {
  case error(statusCode: Int, data: Data)
  case notConnected
  case cancelled
  case generic(Error)
  case urlGeneration
}

// MARK: - NetworkError extension
extension NetworkError {
  public var isNotFoundError: Bool {
    return hasStatusCode(404)
  }

  public func hasStatusCode(_ codeError: Int) -> Bool {
    switch self {
    case let .error(code, _):
      return code == codeError
    default: return false
    }
  }
}

public func printIfDebug(_ string: String) {
  #if DEBUG
  print(string)
  #endif
}
