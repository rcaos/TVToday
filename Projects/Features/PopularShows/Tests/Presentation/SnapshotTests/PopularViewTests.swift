//
//  PopularViewTests.swift
//  PopularShowsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import SnapshotTesting

@testable import PopularShows
@testable import Shared

class PopularViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewModel = PopularViewModelMock(state: .loading)

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen() {
    let firsPageCells = buildFirstPage().results!.map { TVShowCellViewModel(show: $0) }
    let viewModel = PopularViewModelMock(state: .paging(firsPageCells, next: 2) )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (buildFirstPage().results + buildSecondPage().results)
      .map { TVShowCellViewModel(show: $0) }
    let viewModel = PopularViewModelMock(state: .populated(totalCells) )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewModel = PopularViewModelMock(state: .empty)

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewModel = PopularViewModelMock(state: .error("Error to Fetch Shows") )

    let viewController = PopularsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    let lightViewController = PopularsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}

// MARK: - Helper
func configureWith(_ viewController: UIViewController, style: UIUserInterfaceStyle) {
  viewController.overrideUserInterfaceStyle = style
  _ = viewController.view
}
