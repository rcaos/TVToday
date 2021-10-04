//
//  VisitedShowViewModel+Mock.swift
//  SearchShows-Unit-Tests
//
//  Created by Jeans Ruiz on 8/7/20.
//

import RxSwift
@testable import SearchShows
@testable import Persistence

final class VisitedShowViewModelMock: VisitedShowViewModelProtocol {
  var selectedShow = BehaviorSubject<Int>(value: 0)
  var shows: Observable<[ShowVisited]>
  weak var delegate: VisitedShowViewModelDelegate?
  private var showsSubject: BehaviorSubject<[ShowVisited]>

  init(showsMock: [ShowVisited]) {
    showsSubject = BehaviorSubject(value: showsMock)
    shows = showsSubject.asObservable()
  }
}
