//
//  AiringTodayViewTests.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import SnapshotTesting

@testable import AiringToday

class AiringTodayViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewModel = AiringTodayViewModelMock(state: .loading)

    let viewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    let firsPageCells = buildFirstPageSnapshot().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let viewModel = AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) )

    let viewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (buildFirstPageSnapshot().results + buildSecondPageSnapshot().results)
      .map { AiringTodayCollectionViewModel(show: $0) }
    let viewModel = AiringTodayViewModelMock(state: .populated(totalCells) )

    let viewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewModel = AiringTodayViewModelMock(state: .empty )

    let viewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewModel = AiringTodayViewModelMock(state: .error("Error to Fetch Shows") )

    let viewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = AiringTodayViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}

// MARK: - Helper
func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
