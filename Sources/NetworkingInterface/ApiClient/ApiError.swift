//
//  Created by Jeans Ruiz on 13/08/23.
//

import Foundation

public struct ApiError: Error, LocalizedError {
  public let errorDump: String
  public let file: String
  public let line: UInt
  public let message: String
  public let rawError: Error

  public init(
    error: Error,
    file: StaticString = #fileID,
    line: UInt = #line
  ) {
    var string = ""
    dump(error, to: &string)
    self.errorDump = string
    self.file = String(describing: file)
    self.line = line
    self.message = error.localizedDescription
    self.rawError = error
  }

  public var errorDescription: String? {
    self.message
  }
}
