//
//  AiringTodayViewTests_Dark.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import SnapshotTesting
import RxSwift

@testable import AiringToday
@testable import Shared

class AiringTodayViewTestsDark: XCTestCase {

  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  let secondShow = TVShow.stub(id: 2, name: "title2 🔫", posterPath: "/2",
                               backDropPath: "/back2", overview: "overview2")
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")

  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow],
                                         totalResults: 3,
                                         totalPages: 2)

  lazy var secondPage = TVShowResult.stub(page: 2,
                                          results: [thirdShow],
                                          totalResults: 3,
                                          totalPages: 2)

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .loading) )
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Dark() {
    // given
    let firsPageCells = firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }

    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Light() {
    // given
    let firsPageCells = firstPage.results!.map { AiringTodayCollectionViewModel(show: $0) }

    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (self.firstPage.results + self.secondPage.results)
      .map { AiringTodayCollectionViewModel(show: $0) }

    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .populated(totalCells) ))
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .empty ) )
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // when
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .error("Error to Fetch Shows") ) )
    viewController.overrideUserInterfaceStyle = .dark

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
