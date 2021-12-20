//
//  ShowListViewTestsLight.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import SnapshotTesting
import XCTest
import RxSwift

@testable import TVShowsList
@testable import Shared

class TVShowListViewTestsLight: XCTestCase {

  let firstShow = TVShow.stub(id: 1, name: "title1 🐶", posterPath: "/1",
                              backDropPath: "/back1", overview: "overview")
  let secondShow = TVShow.stub(id: 2, name: "title2 🔫", posterPath: "/2",
                               backDropPath: "/back2", overview: "overview2")
  let thirdShow = TVShow.stub(id: 3, name: "title3 🚨", posterPath: "/3",
                              backDropPath: "/back3", overview: "overview3")

  lazy var firstPage = TVShowResult.stub(page: 1,
                                         results: [firstShow, secondShow],
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
    // given
    let viewModel = TVShowListViewModelMock(state: .loading)

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = firstPage.results!.map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .paging(firsPageCells, next: 2) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (self.firstPage.results + self.secondPage.results)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .populated(totalCells) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .empty)

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }
}
