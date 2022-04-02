//
//  VisitedShowViewModel.swift
//  SearchShows
//
//  Created by Jeans Ruiz on 7/5/20.
//

import Foundation
import Combine
import Persistence

protocol VisitedShowViewModelDelegate: AnyObject {
  func visitedShowViewModel(_ visitedShowViewModel: VisitedShowViewModelProtocol,
                            didSelectRecentlyVisitedShow id: Int)
}

protocol VisitedShowViewModelProtocol {
  // MARK: - Input
  func showDidSelected(id: Int)

  // MARK: - Output
  var shows: CurrentValueSubject<[ShowVisited], Never> { get }
  var delegate: VisitedShowViewModelDelegate? { get set }
}

final class VisitedShowViewModel: VisitedShowViewModelProtocol, Hashable {
  weak var delegate: VisitedShowViewModelDelegate?
  private let selectedShow = CurrentValueSubject<Int, Never>(0)
  let shows: CurrentValueSubject<[ShowVisited], Never>
  var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(shows: [ShowVisited]) {
    self.shows = CurrentValueSubject<[ShowVisited], Never>(shows)
    subscribe()
  }

  func showDidSelected(id: Int) {
    selectedShow.send(id)
  }

  private func subscribe() {
    selectedShow
      .filter { $0 != 0 }
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] showId in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.visitedShowViewModel(strongSelf, didSelectRecentlyVisitedShow: showId)
      })
      .store(in: &disposeBag)
  }

  static func == (lhs: VisitedShowViewModel, rhs: VisitedShowViewModel) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(shows.value.hashValue)
  }
}
