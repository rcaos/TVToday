//
//  DefaultDataTransferErrorResolver.swift
//  Networking
//
//  Created by Jeans Ruiz on 19/03/22.
//

import NetworkingInterface

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
  public init() { }

  public func resolve(error: NetworkError) -> Error {
    return error
  }
}
