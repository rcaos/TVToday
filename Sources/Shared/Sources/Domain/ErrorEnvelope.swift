//
//  Created by Jeans Ruiz on 6/26/20.
//

import Foundation
import NetworkingInterface

#warning("Use ApiError instead")
public struct ErrorEnvelope {
  public let errorMessages: [String]
  public let apiCode: TodayCode?

  public init(
    errorMessages: [String] = [],
    apiCode: TodayCode? = nil
  ) {
    self.errorMessages = errorMessages
    self.apiCode = apiCode
  }

  public enum TodayCode: String {
    // Codes defined by the client
    case MappingFailed = "mapping_failed"
    case TransferError = "transfer_error"
  }
}

extension ErrorEnvelope: Error { }
