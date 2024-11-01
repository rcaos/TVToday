//
//  Created by Jeans on 9/24/19.
//

import Foundation
import Combine
import Shared

protocol SeasonListViewModelDelegate: AnyObject {
  func seasonListViewModel(_ seasonListViewModel: SeasonListViewModelProtocol, didSelectSeason number: Int)
}

protocol SeasonListViewModelProtocol {

  // MARK: - Input
  // MARK: - TODO, refactor this, change signature, choose between delegate and Streams.
  func selectSeason(_ season: Int)
  func selectSeason(seasonNumber: Int)

  // MARK: - Output
  var seasons: CurrentValueSubject<[Int], Never> { get }
  var seasonSelected: CurrentValueSubject<Int, Never> { get }
  func getModel(for season: Int) -> SeasonEpisodeViewModel

  var delegate: SeasonListViewModelDelegate? { get set }
}

final class SeasonListViewModel: SeasonListViewModelProtocol {
  private var seasonList: [Int]
  private let inputSelectedSeason = CurrentValueSubject<Int, Never>(0)

  weak var delegate: SeasonListViewModelDelegate?
  private var disposeBag = Set<AnyCancellable>()

  let seasons: CurrentValueSubject<[Int], Never>
  let seasonSelected = CurrentValueSubject<Int, Never>(0)

  // MARK: Initalizer
  init(seasonList: [Int]) {
    self.seasonList = seasonList
    seasons = CurrentValueSubject(seasonList)
    subscribe()
  }

  deinit {
    print("deinit \(Self.self)")
  }

  // MARK: - Public
  func getModel(for season: Int) -> SeasonEpisodeViewModel {
    return SeasonEpisodeViewModel(seasonNumber: season)
  }

  // MARK: - TODO Review  method + Observable or Two methods only
  func selectSeason(_ season: Int) {
    if seasonList.contains(season) {
      seasonSelected.send(season)
    }
  }

  func selectSeason(seasonNumber: Int) {
    inputSelectedSeason.send(seasonNumber)
  }

  private func subscribe() {
    inputSelectedSeason
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] season in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.seasonListViewModel(strongSelf, didSelectSeason: season)
      })
      .store(in: &disposeBag)
  }
}

// MARK: - Data Source
enum SectionSeasonsList: Hashable {
  case season
}
