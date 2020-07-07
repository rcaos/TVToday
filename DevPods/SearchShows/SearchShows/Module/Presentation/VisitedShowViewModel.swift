//
//  VisitedShowViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import Foundation
import RxSwift
import RxDataSources
import Persistence

protocol VisitedShowViewModelDelegate: class {
  
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModel, didSelectRecentlyVisitedShow id: Int)
}

final class VisitedShowViewModel {
  
  weak var delegate: VisitedShowViewModelDelegate?
  
  private var showsObservableSubject: BehaviorSubject<[ShowVisited]>
  
  var input: Input
  
  var output: Output
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(shows: [ShowVisited]) {
    self.showsObservableSubject = BehaviorSubject(value: shows)
    
    self.input = Input()
    self.output = Output(shows: showsObservableSubject.asObservable())
    
    subscribe()
  }
  
  private func subscribe() {
    input.selectedShow
      .filter { $0 != 0 }
      .subscribe(onNext: { [weak self] showId in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.visitedShowViewModel(strongSelf, didSelectRecentlyVisitedShow: showId)
      })
      .disposed(by: disposeBag)
  }
}

extension VisitedShowViewModel {
  public struct Input {
    let selectedShow = BehaviorSubject<Int>(value: 0)
  }
  
  public struct Output {
    let shows: Observable<[ShowVisited]>
  }
}

// MARK: - TODO, move

struct VisitedShowSection {
  var header: String
  var items: [Item]
}

extension VisitedShowSection: SectionModelType {
  
  typealias Item = ShowVisited
  
  init(original: VisitedShowSection, items: [Item]) {
    self = original
    self.items = items
  }
}
