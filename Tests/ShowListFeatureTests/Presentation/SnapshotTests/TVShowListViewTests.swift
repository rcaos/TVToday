//
//  TVShowListViewTests.swift
//  TVShowsListTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import CommonMocks
import SnapshotTesting
import XCTest
import Shared
import UI

@testable import ShowListFeature

#warning("todo, recover these tests")
class TVShowListViewTests: XCTestCase {

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
//    defaultScheduler = .immediate
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewModel = TVShowListViewModelMock(state: .loading)

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    let firsPageCells = buildFirstPageSnapshot().showsList.map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .paging(firsPageCells, next: 2) )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (buildFirstPageSnapshot().showsList + buildSecondPageSnapshot().showsList)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = TVShowListViewModelMock(state: .populated(totalCells) )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewModel = TVShowListViewModelMock(state: .empty)

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewModel = TVShowListViewModelMock(state: .error("Error to Fetch Shows") )

    let viewController = TVShowListViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = TVShowListViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }
}

// MARK: - Helper
func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
