//
//  ErrorEnvelope.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import NetworkingInterface

public struct ErrorEnvelope {
  public let errorMessages: [String]
  public let apiCode: TodayCode?
  public let transferError: DataTransferError?

  public init(
    errorMessages: [String] = [],
    apiCode: TodayCode? = nil,
    transferError: DataTransferError? = nil
  ) {
    self.errorMessages = errorMessages
    self.apiCode = apiCode
    self.transferError = transferError
  }

  public enum TodayCode: String {
    // Codes defined by the client
    case MappingFailed = "mapping_failed"
    case TransferError = "transfer_error"
  }
}

extension ErrorEnvelope: Error { }
