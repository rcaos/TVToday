//
//  FetchShowsUseCaseMock.swift
//  
//
//  Created by Jeans Ruiz on 14/05/22.
//

import Foundation
import Combine
import NetworkingInterface
@testable import Shared

import ConcurrencyExtras

public class FetchShowsUseCaseMock: FetchTVShowsUseCase {

  public var error: ApiError?
  public var result: TVShowPage?

  public init() { }

  public func execute(request: FetchTVShowsUseCaseRequestValue) async -> TVShowPage? {
    await Task.yield()
    if error != nil {
      return nil
    }

    return result
  }
}
