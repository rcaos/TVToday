//
//  ShowListViewTestsLight.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import SnapshotTesting
import XCTest

@testable import TVShowsList
@testable import Shared

class TVShowListViewTestsLight: XCTestCase {

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
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .paging(firsPageCells, next: 2) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (buildFirstPage().results + buildSecondPage().results)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .populated(totalCells) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .empty)

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
