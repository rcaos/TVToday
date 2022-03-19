//
//  DefaultDataTransferErrorLogger.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import NetworkingInterface

public final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
  public init() { }

  public func log(error: Error) {
    printIfDebug("-------------")
    printIfDebug("\(error)")
  }
}
