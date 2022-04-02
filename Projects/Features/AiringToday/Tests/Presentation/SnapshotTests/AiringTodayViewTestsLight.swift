//
//  AiringTodayViewTests.swift
//  AiringToday-Unit-Tests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import XCTest
import SnapshotTesting

@testable import AiringToday
@testable import Shared

class AiringTodayViewTestsLight: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .loading) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Dark() {
    let firsPageCells = makeFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Light() {
    let firsPageCells = makeFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (makeFirstPage().results + makeSecondPage().results)
      .map { AiringTodayCollectionViewModel(show: $0) }
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .populated(totalCells) ))
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .empty ) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .error("Error to Fetch Shows") ) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
