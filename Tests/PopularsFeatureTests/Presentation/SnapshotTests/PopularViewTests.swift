//
//  PopularViewTests.swift
//  PopularShowsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import CommonMocks
@testable import PopularsFeature
import Shared
import SnapshotTesting
import UI
import XCTest

class PopularViewTests: XCTestCase {

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    defaultScheduler = .immediate
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewModel = PopularViewModelMock(state: .loading)

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    let firsPageCells = buildFirstPageSnapshot().showsList.map { TVShowCellViewModel(show: $0) }
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (buildFirstPageSnapshot().showsList + buildSecondPageSnapshot().showsList)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewModel = PopularViewModelMock(state: .empty)

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.98))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.98))
  }
}

// MARK: - Helper
func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
