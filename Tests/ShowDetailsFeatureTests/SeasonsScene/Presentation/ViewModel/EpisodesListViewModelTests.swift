//
//  EpisodesListViewModelTests.swift
//  EpisodesListViewModelTests-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import XCTest
import CombineSchedulers
@testable import ShowDetailsFeature
@testable import Shared

class EpisodesListViewModelTests: XCTestCase {

  let detailResult = TVShowDetailResult.stub()

  let episodes: [Episode] = {
    return [
      Episode.stub(id: 1, episodeNumber: 1, name: "Chapter #1"),
      Episode.stub(id: 2, episodeNumber: 2, name: "Chapter #2"),
      Episode.stub(id: 3, episodeNumber: 3, name: "Chapter #3")
    ]
  }()

  var fetchTVShowDetailsUseCaseMock: FetchTVShowDetailsUseCaseMock!
  var fetchEpisodesUseCaseMock: FetchEpisodesUseCaseMock!
  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    fetchTVShowDetailsUseCaseMock = FetchTVShowDetailsUseCaseMock()
    fetchEpisodesUseCaseMock = FetchEpisodesUseCaseMock()
    disposeBag = []
  }

  func test_when_useCase_Is_Not_Responds_Yet_ViewModel_Should_contains_Loading_State() {
    // given
    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: .immediate)

    let expected = [EpisodesListViewModel.ViewState.loading]
    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0)}).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Loading State")
  }

  func test_when_ShowDetails_useCase_And_Seasons_useCase_return_OK_ViewModel_Should_Contains_Populated_State() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: .immediate)

    let expected = [
      EpisodesListViewModel.ViewState.loading,
      EpisodesListViewModel.ViewState.populated
    ]
    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0)}).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }

  func test_when_UseCase_GetData_return_OK_ViewModel_Should_Contains_Data_Of_List_Episodes() {
    // given
    let headerViewModel = SeasonHeaderViewModel(showDetail: self.detailResult)
    let episodesSection = self.episodes
      .map { EpisodeSectionModelType(episode: $0) }
      .map { SeasonsSectionItem.episodes(items: $0) }
    let dataExpected: [SeasonsSectionModel] = [
      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
      .seasons(items: [.seasons]),
      .episodes(items: episodesSection)
    ]

    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: .immediate)

    let expected = [ [], dataExpected ]
    var received = [[SeasonsSectionModel]]()

    sut.data.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Populated State")
  }

  func test_when_useCase_Is_Not_Responds_Yet_ViewModel_Should_contains_Error_State() {
    // given
    fetchTVShowDetailsUseCaseMock.error = .noResponse
    fetchEpisodesUseCaseMock.error = .noResponse

    let scheduler = DispatchQueue.test

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: scheduler.eraseToAnyScheduler())

    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // then
    XCTAssertEqual([.loading, .error("")], received, "Should contains Error State")

    // and When, Recovered from Error
    fetchTVShowDetailsUseCaseMock.error = nil
    fetchTVShowDetailsUseCaseMock.result = self.detailResult

    fetchEpisodesUseCaseMock.error = nil
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    sut.refreshView()
    scheduler.advance(by: 1)

    // then
    XCTAssertEqual([.loading, .error(""), .populated], received, "Should contains Populated State")
  }

  func test_when_useCase_Returns_Zero_Episodes_Viewmodel_should_Contains_Empty_State() {
    // given
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: [], seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: .immediate)

    // MARK: - TODO
    let expected = [
      EpisodesListViewModel.ViewState.loading,
      EpisodesListViewModel.ViewState.empty,
      EpisodesListViewModel.ViewState.loadingSeason,
      EpisodesListViewModel.ViewState.empty
    ]
    var received = [EpisodesListViewModel.ViewState]()

    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()

    // then
    XCTAssertEqual(expected, received, "Should contains Loading State")
  }

  func test_When_Ask_For_Different_Season_And_UseCase_Doesnt_Respond_Yet_ViewModel_Should_Contains_Loading_Season_State() {
    // given
    let scheduler = DispatchQueue.test
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: scheduler.eraseToAnyScheduler())

    var received = [EpisodesListViewModel.ViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // when
    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // UseCase not response yet
    fetchEpisodesUseCaseMock.result = nil
    fetchEpisodesUseCaseMock.error = nil

    sut.getViewModelForAllSeasons()?.selectSeason(seasonNumber: 2)
    scheduler.advance(by: 1)

    XCTAssertEqual([.loading, .populated, .loadingSeason], received)
  }

  func test_When_Ask_For_Different_Season_And_UseCase_Return_Error_ViewModel_Should_Contains_Loading_Season_State() {
    // given
    let scheduler = DispatchQueue.test

    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: scheduler.eraseToAnyScheduler())

    var received = [EpisodesListViewModel.ViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // UseCase responds with error
    fetchEpisodesUseCaseMock.result = nil
    fetchEpisodesUseCaseMock.error = .noResponse

    // when
    sut.getViewModelForAllSeasons()?.selectSeason(seasonNumber: 2)
    scheduler.advance(by: 1)

    // then
    XCTAssertEqual([.loading, .populated, .loadingSeason, .errorSeason("")], received)
  }

  func test_When_Ask_For_Different_Season_And_UseCase_Return_OK_ViewModel_Should_Contains_populated() {
    let scheduler = DispatchQueue.test
    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: .immediate)
    var received = [EpisodesListViewModel.ViewState]()
    sut.viewState.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // Given UseCase responds with Data
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
    fetchEpisodesUseCaseMock.error = nil

    // When
    sut.getViewModelForAllSeasons()?.selectSeason(seasonNumber: 2)
    scheduler.advance(by: 1)

    // Then
    XCTAssertEqual([.loading, .populated, .loadingSeason, .populated], received)
  }

  func test_When_Ask_For_Different_Season_And_UseCase_Return_OK_ViewModel_Should_Contains_Data_With_Episodes() {
    let firstEpisodes = self.episodes
      .map { EpisodeSectionModelType(episode: $0)}
      .map { SeasonsSectionItem.episodes(items: $0) }
    let headerViewModel = SeasonHeaderViewModel(showDetail: self.detailResult)

    let firstSeason: [SeasonsSectionModel] = [
      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
      .seasons(items: [.seasons]),
      .episodes(items: firstEpisodes)
    ]

    let loadingSection: [SeasonsSectionModel] = [
      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
      .seasons(items: [.seasons]),
      .episodes(items: [])
    ]

    let secondEpisodes = self.episodes
      .map { EpisodeSectionModelType(episode: $0)}
      .map { SeasonsSectionItem.episodes(items: $0) }
    let secondSeason: [SeasonsSectionModel] = [
      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
      .seasons(items: [.seasons]),
      .episodes(items: secondEpisodes)
    ]

    fetchTVShowDetailsUseCaseMock.result = self.detailResult
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)

    // Given
    let scheduler = DispatchQueue.test
    let sut: EpisodesListViewModelProtocol =
    EpisodesListViewModel(tvShowId: 1,
                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
                          scheduler: scheduler.eraseToAnyScheduler())
    var received = [[SeasonsSectionModel]]()
    sut.data.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    sut.viewDidLoad()
    scheduler.advance(by: 1)

    // Second Season responds
    fetchEpisodesUseCaseMock.result = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
    fetchEpisodesUseCaseMock.error = nil

    // When
    sut.getViewModelForAllSeasons()?.selectSeason(seasonNumber: 2)
    scheduler.advance(by: 1)

    // Then
    XCTAssertEqual([[], firstSeason, loadingSection, secondSeason], received)
  }
}
