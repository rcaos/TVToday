//
//  SearchShowsOptionsViewTests.swift
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

class SearchShowsOptionsViewTests: XCTestCase {

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .loading)

    // when
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let sections = createSectionModel(showsVisited: buildShowVisited(), genres: buildGenres())
    let viewModel = SearchOptionsViewModelMock(state: .populated, sections: sections)

    // when
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .empty, sections: [])

    // when
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .error("Error to Fetch Genres"), sections: [])

    // when
    let viewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = SearchOptionsViewController(viewModel: viewModel)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
