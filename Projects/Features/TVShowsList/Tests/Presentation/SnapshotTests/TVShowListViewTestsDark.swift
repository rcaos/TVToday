//
//  TVShowListViewTestsDark.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import SnapshotTesting
import XCTest

@testable import TVShowsList
@testable import Shared

class TVShowListViewTestsDark: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .loading)

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .paging(firsPageCells, next: 2) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (buildFirstPage().results + buildSecondPage().results)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .populated(totalCells) )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .empty)

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = TVShowListViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = TVShowListViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
