//
//  ResultsSearchViewDarkTests.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import SnapshotTesting
import XCTest

@testable import SearchShows
@testable import Shared
@testable import Persistence

class ResultsSearchViewDarkTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewInitial_thenShowInitialScreen() {
    // given
    let recent = ["Breaking Bad", "Rick and Morty", "Dark"]
    let dataSource = createSectionModel(recentSearchs: recent, resultShows: [])
    let viewModel = ResultsSearchViewModelMock(state: .initial, source: dataSource)

    let viewController = ResultsSearchViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .loading)
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsPopulated_thenShowPopulatedScreen() {
    // given
    let shows = [
      TVShow.stub(id: 1, name: "Show 1", voteAverage: 1.0, posterPath: nil),
      TVShow.stub(id: 2, name: "Show 2", voteAverage: 2.0, posterPath: nil),
      TVShow.stub(id: 3, name: "Show 3", voteAverage: 3.0, posterPath: nil)
    ]
    let dataSource = createSectionModel(recentSearchs: [], resultShows: shows)

    let viewModel = ResultsSearchViewModelMock(state: .populated, source: dataSource)

    let viewController = ResultsSearchViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .empty)
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewDidError_thenShowErrorScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .error("Error to Fetch Shows"))
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    viewController.overrideUserInterfaceStyle = .dark
    _ = viewController.view

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
