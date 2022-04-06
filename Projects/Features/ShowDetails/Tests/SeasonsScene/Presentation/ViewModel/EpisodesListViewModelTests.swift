//
//  EpisodesListViewModelTests.swift
//  EpisodesListViewModelTests-Unit-Tests
//
//  Created by Jeans Ruiz on 7/28/20.
//

import Combine
import XCTest
import CombineSchedulers
@testable import ShowDetails
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

  // MARK: - TODO, Fix scheduler to test this cases
//  func test_When_Ask_For_Different_Season_And_UseCase_Doesnt_Respond_Yet_ViewModel_Should_Contains_Loading_Season_State() {
//    // given
//    // let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//    let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    fetchEpisodesUseCaseMock.result = seasonResult
//
//    let _: EpisodesListViewModelProtocol =
//    EpisodesListViewModel(tvShowId: 1,
//                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
//                          scheduler: .immediate)
//    //
//    //          viewModel.viewState
//    //            .distinctUntilChanged()
//    //            .subscribe { event in
//    //              statesObserver.on(event)
//    //            }
//    //            .disposed(by: disposeBag)
//    //
//    //          let seasonViewModel = SeasonListViewModelMock()
//    //
//    //          // when
//    //          viewModel.viewDidLoad()
//    //
//    //          // not response yet
//    //          fetchEpisodesUseCaseMock.result = nil
//    //          fetchEpisodesUseCaseMock.error = nil
//    //
//    //          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//    //
//    //          // when
//    //          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//    //            .next(0, .loading) ,
//    //            .next(0, .populated) ,
//    //            .next(0, .loadingSeason)
//    //          ]
//    //
//    //          expect(statesObserver.events).toEventually(equal(expected))
//  }
//
//  // MARK: - TODO, Fix scheduler
//  func test_When_Ask_For_Different_Season_And_UseCase_Return_Error_ViewModel_Should_Contains_Loading_Season_State() {
//    // given
////    let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//    let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    fetchEpisodesUseCaseMock.result = seasonResult
//
//    let _: EpisodesListViewModelProtocol =
//    EpisodesListViewModel(tvShowId: 1,
//                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
//                          scheduler: .immediate)
//    //
//    //          viewModel.viewState
//    //            .distinctUntilChanged()
//    //            .subscribe { event in
//    //              statesObserver.on(event)
//    //            }
//    //            .disposed(by: disposeBag)
//    //
//    //          let seasonViewModel = SeasonListViewModelMock()
//    //
//    //          // when
//    //          viewModel.viewDidLoad()
//    //
//    //          // not response yet
//    //          fetchEpisodesUseCaseMock.error = CustomError.genericError
//    //
//    //          // select next Season
//    //          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//    //
//    //          // when
//    //          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//    //            .next(0, .loading),
//    //            .next(0, .populated),
//    //            .next(0, .loadingSeason),
//    //            .next(0, .errorSeason(CustomError.genericError.localizedDescription))
//    //          ]
//    //
//    //          expect(statesObserver.events).toEventually(equal(expected))
//    //        }
//    //      }
//  }
//
//  func test_When_Ask_For_Different_Season_And_UseCase_Return_OK_ViewModel_Should_Contains_populated() {
//    // given
////    let statesObserver = scheduler.createObserver(EpisodesListViewModel.ViewState.self)
//
//    let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    fetchEpisodesUseCaseMock.result = seasonResult
//
//    let _: EpisodesListViewModelProtocol =
//    EpisodesListViewModel(tvShowId: 1,
//                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
//                          scheduler: .immediate)
//    //
//    //          viewModel.viewState
//    //            .distinctUntilChanged()
//    //            .subscribe { event in
//    //              statesObserver.on(event)
//    //            }
//    //            .disposed(by: disposeBag)
//    //
//    //          let seasonViewModel = SeasonListViewModelMock()
//    //
//    //          // when
//    //          viewModel.viewDidLoad()
//    //
//    //          let secondSeason = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
//    //          fetchEpisodesUseCaseMock.result = secondSeason
//    //          fetchEpisodesUseCaseMock.error = nil
//    //
//    //          // select next Season
//    //          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//    //
//    //          // when
//    //          let expected: [Recorded<Event<EpisodesListViewModel.ViewState>>] = [
//    //            .next(0, .loading),
//    //            .next(0, .populated),
//    //            .next(0, .loadingSeason),
//    //            .next(0, .populated)
//    //          ]
//    //
//    //          expect(statesObserver.events).toEventually(equal(expected))
//  }
//
//  func test_When_Ask_For_Different_Season_And_UseCase_Return_OK_ViewModel_Should_Contains_Data_With_Episodes() {
//    // given
////    let episodesObserver = scheduler.createObserver([SeasonsSectionModel].self)
//
//    let numberOfSeasons = 9
//
//    let firstEpisodes = self.episodes
//      .map { EpisodeSectionModelType(episode: $0)}
//      .map { SeasonsSectionItem.episodes(items: $0) }
//    let headerViewModel = SeasonHeaderViewModel(showDetail: self.detailResult)
//
//    let firstSeason: [SeasonsSectionModel] = [
//      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
//      .seasons(items: [.seasons]),
//      .episodes(items: firstEpisodes)
//    ]
//
//    let loadingSection: [SeasonsSectionModel] = [
//      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
//      .seasons(items: [.seasons]),
//      .episodes(items: [])
//    ]
//
//    let secondEpisodes = self.episodes
//      .map { EpisodeSectionModelType(episode: $0)}
//      .map { SeasonsSectionItem.episodes(items: $0) }
//    let secondSeason: [SeasonsSectionModel] = [
//      .headerShow(items: [.headerShow(viewModel: headerViewModel)]),
//      .seasons(items: [.seasons]),
//      .episodes(items: secondEpisodes)
//    ]
//
//    let seasonResult = SeasonResult(id: "1", episodes: self.episodes, seasonNumber: 1)
//
//    fetchTVShowDetailsUseCaseMock.result = self.detailResult
//    fetchEpisodesUseCaseMock.result = seasonResult
//
//    let sut: EpisodesListViewModelProtocol =
//    EpisodesListViewModel(tvShowId: 1,
//                          fetchDetailShowUseCase: fetchTVShowDetailsUseCaseMock,
//                          fetchEpisodesUseCase: fetchEpisodesUseCaseMock,
//                          scheduler: .immediate)
//    //
//    //          viewModel.data
//    //            .distinctUntilChanged()
//    //            .subscribe { event in
//    //              episodesObserver.on(event)
//    //            }
//    //            .disposed(by: disposeBag)
//    //
//    //          let seasonViewModel = SeasonListViewModelMock()
//    //
//    //          // when
//    //          viewModel.viewDidLoad()
//    //
//    //          let secondSeasonResult = SeasonResult(id: "2", episodes: self.episodes, seasonNumber: 2)
//    //          fetchEpisodesUseCaseMock.result = secondSeasonResult
//    //          fetchEpisodesUseCaseMock.error = nil
//    //
//    //          // select next Season
//    //          viewModel.seasonListViewModel(seasonViewModel, didSelectSeason: 2)
//    //
//    //          // when
//    //          let expected: [Recorded<Event<[SeasonsSectionModel]>>] = [
//    //            .next(0, []),
//    //            .next(0, firstSeason),
//    //            .next(0, loadingSection),
//    //            .next(0, secondSeason)
//    //          ]
//    //
//    //          expect(episodesObserver.events).toEventually(equal(expected))
//  }
}
