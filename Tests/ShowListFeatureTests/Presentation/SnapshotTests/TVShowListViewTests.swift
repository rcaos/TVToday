//
//  TVShowListViewTests.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import CommonMocks
import SnapshotTesting
import XCTest
import UI

@testable import ShowListFeature

class TVShowListViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewModel = TVShowListViewModelMock(state: .loading)

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    let firsPageCells = buildFirstPageSnapshot().showsList.map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .paging(firsPageCells, next: 2) )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (buildFirstPageSnapshot().showsList + buildSecondPageSnapshot().showsList)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .populated(totalCells) )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewModel = TVShowListViewModelMock(state: .empty)

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewModel = TVShowListViewModelMock(state: .error("Error to Fetch Shows") )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }
}

// MARK: - Helper
func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
