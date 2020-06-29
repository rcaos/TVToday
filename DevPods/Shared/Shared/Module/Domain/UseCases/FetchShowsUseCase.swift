//
//  FetchShowsMoviesUseCase.swift
//  TVToday
//
//  Created by Jeans on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

public protocol FetchTVShowsUseCase {

  func execute(requestValue: FetchTVShowsUseCaseRequestValue) -> Observable<TVShowResult>
}

public struct FetchTVShowsUseCaseRequestValue {
  public let page: Int
}
