//
//  PopularViewTests.swift
//  PopularShows-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import XCTest
import SnapshotTesting

@testable import PopularShows
@testable import Shared

class PopularViewTestsLight: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .loading)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    // given
    let firsPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let totalCells = (buildFirstPage().results + buildSecondPage().results)
      .map { TVShowCellViewModel(show: $0) }

    // when
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .empty)

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )

    // when
    let viewController = PopularsViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
