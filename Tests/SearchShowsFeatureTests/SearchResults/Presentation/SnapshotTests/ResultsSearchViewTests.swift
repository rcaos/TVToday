//
//  ResultsSearchViewTests.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 20/12/21.
//

import SnapshotTesting
import XCTest

@testable import SearchShowsFeature
@testable import Shared
@testable import Persistence

class ResultsSearchViewTests: XCTestCase {

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
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))

    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .loading)

    // when
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsPopulated_thenShowPopulatedScreen() {
    // given
    let shows: [TVShowPage.TVShow] = [
      .stub(id: 1, name: "Show 1", voteAverage: 1.0, posterPath: nil),
      .stub(id: 2, name: "Show 2 with a long name, this cell could increase it's height. Other Line and another and another and another and another Line", voteAverage: 2.0, posterPath: nil),
      .stub(id: 3, name: "Show 3", voteAverage: 3.0, posterPath: nil)
    ]
    let dataSource = createSectionModel(recentSearchs: [], resultShows: shows)

    let viewModel = ResultsSearchViewModelMock(state: .populated, source: dataSource)

    // when
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .empty)

    // given
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))

    // given
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewDidError_thenShowErrorScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .error("Error to Fetch Shows"))

    // when
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.1, on: .image(on: .iPhoneSe)))
  }
}
