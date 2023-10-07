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
import UI

class ResultsSearchViewTests: XCTestCase {

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    defaultScheduler = .immediate
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
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.98))

    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.98))
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .loading)

    // when
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
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
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .empty)

    // given
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // given
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewDidError_thenShowErrorScreen() {
    // given
    let viewModel = ResultsSearchViewModelMock(state: .error("Error to Fetch Shows"))

    // when
    let viewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = ResultsSearchViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .dark)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }
}
