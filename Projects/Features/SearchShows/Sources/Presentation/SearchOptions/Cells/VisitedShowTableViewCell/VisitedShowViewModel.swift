//
//  VisitedShowViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import Foundation
import RxSwift
import Persistence

protocol VisitedShowViewModelDelegate: AnyObject {
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModelProtocol,
                            didSelectRecentlyVisitedShow id: Int)
}

protocol VisitedShowViewModelProtocol {
  // MARK: - Input
  var selectedShow: BehaviorSubject<Int> { get }

  // MARK: - Output
  var shows: Observable<[ShowVisited]> { get }
  var delegate: VisitedShowViewModelDelegate? { get set }
}

final class VisitedShowViewModel: VisitedShowViewModelProtocol, Hashable {

  weak var delegate: VisitedShowViewModelDelegate?

  let selectedShow = BehaviorSubject<Int>(value: 0)

  let shows: Observable<[ShowVisited]>

  private var showsObservableSubject: BehaviorSubject<[ShowVisited]>

  private var disposeBag = DisposeBag()

  internal let hashValue: Int

  // MARK: - Initializer
  init(shows: [ShowVisited]) {
    self.showsObservableSubject = BehaviorSubject(value: shows)

    self.shows = showsObservableSubject.asObservable()

    self.hashValue = shows.hashValue

    subscribe()
  }

  private func subscribe() {
    selectedShow
      .filter { $0 != 0 }
      .subscribe(onNext: { [weak self] showId in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.visitedShowViewModel(strongSelf, didSelectRecentlyVisitedShow: showId)
      })
      .disposed(by: disposeBag)
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(hashValue)
  }

  static func == (lhs: VisitedShowViewModel, rhs: VisitedShowViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
