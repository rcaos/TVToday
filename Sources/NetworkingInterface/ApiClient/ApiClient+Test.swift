//
//  Created by Jeans Ruiz on 11/09/23.
//

import Foundation

extension ApiClient {
  /// For Preview Version
  public static var noop: ApiClient = {
    return ApiClient(
      apiRequest: { _ in
        return (Data(), .init())
      },
      logError: {
        debugPrint("debugPrint: \($0)")
      }
    )
  }()

  /// For testing purposes
  public static var testMock: ApiClient = {
    return ApiClient(
      apiRequest: {
        throw UnimplementedFailure(description: "Not implemented for: \($0)")
      },
      logError: {
        fatalError("Unimplemented for: \($0)")
      }
    )
  }()

  public struct UnimplementedFailure: Error {
    public let description: String
  }
}
