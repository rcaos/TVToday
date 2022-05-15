//
//  FetchShowsMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine
import NetworkingInterface

public protocol FetchTVShowsUseCase {
  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> AnyPublisher<TVShowPage, DataTransferError>
}

public struct FetchTVShowsUseCaseRequestValue {
  public let page: Int

  public init(page: Int) {
    self.page = page
  }
}
