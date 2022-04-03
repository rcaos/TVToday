//
//  PopularViewTestsDark.swift
//  PopularShowsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import SnapshotTesting

@testable import PopularShows
@testable import Shared

class PopularViewTestsDark: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .loading)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (buildFirstPage().results + buildSecondPage().results)
      .map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .empty)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
