//
//  AiringTodayViewTests_Dark.swift
//  AiringTodayTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import XCTest
import SnapshotTesting

@testable import AiringToday

class AiringTodayViewTestsDark: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .loading) )
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Dark() {
    let firsPageCells = makeFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }

    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPaging_thenShowPagingScreen_Light() {
    let firsPageCells = makeFirstPage().results!.map { AiringTodayCollectionViewModel(show: $0) }
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .paging(firsPageCells, next: 2) ) )
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    let totalCells = (makeFirstPage().results + makeSecondPage().results)
      .map { AiringTodayCollectionViewModel(show: $0) }
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .populated(totalCells) ))
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .empty ) )
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    let viewController = AiringTodayViewController(viewModel: AiringTodayViewModelMock(state: .error("Error to Fetch Shows") ) )
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
