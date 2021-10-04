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

final class VisitedShowViewModel: VisitedShowViewModelProtocol {

  weak var delegate: VisitedShowViewModelDelegate?

  let selectedShow = BehaviorSubject<Int>(value: 0)

  let shows: Observable<[ShowVisited]>

  private var showsObservableSubject: BehaviorSubject<[ShowVisited]>

  private var disposeBag = DisposeBag()

  // MARK: - Initializer
  init(shows: [ShowVisited]) {
    self.showsObservableSubject = BehaviorSubject(value: shows)

    self.shows = showsObservableSubject.asObservable()

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
}
