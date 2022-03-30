//
//  SearchShowsOptionsViewLightTests.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import SnapshotTesting
import XCTest

@testable import SearchShows
@testable import Shared
@testable import Persistence

class SearchShowsOptionsViewLightTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewController = SearchOptionsViewController(viewModel: SearchOptionsViewModelMock(state: .loading) )
    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let sections = createSectionModel(showsVisited: buildShowVisited(), genres: buildGenres())

    let viewModel = SearchOptionsViewModelMock(state: .populated, sections: sections)
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    _ = viewController.view

    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .empty, sections: [])
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    _ = viewController.view

    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .error("Error to Fetch Genres"), sections: [])
    let viewController = SearchOptionsViewController(viewModel: viewModel)

    viewController.overrideUserInterfaceStyle = .light
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
