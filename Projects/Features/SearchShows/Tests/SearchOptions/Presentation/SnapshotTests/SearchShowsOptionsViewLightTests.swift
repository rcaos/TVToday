//
//  SearchShowsOptionsViewLightTests.swift
//  SearchShowsTests
//
//  Created by Jeans Ruiz on 7/30/20.
//

import SnapshotTesting
import RxSwift
import XCTest

@testable import SearchShows
@testable import Shared
@testable import Persistence

class SearchShowsOptionsViewLightTests: XCTestCase {

  private let showsVisited: [ShowVisited] = [
    ShowVisited.stub(id: 1, pathImage: ""),
    ShowVisited.stub(id: 2, pathImage: ""),
    ShowVisited.stub(id: 3, pathImage: "")
  ]

  private let genres: [Genre] = [
    Genre.stub(id: 1, name: "Genre 1"),
    Genre.stub(id: 2, name: "Genre 2")
  ]

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let viewController = SearchOptionsViewController(viewModel: SearchOptionsViewModelMock(state: .loading) )
    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let sections = createSectionModel(showsVisited: showsVisited, genres: genres)

    let viewModel = SearchOptionsViewModelMock(state: .populated, sections: sections)
    let viewController = SearchOptionsViewController(viewModel: viewModel)

    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsEmpty_thenShowEmptyScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .empty, sections: [])
    let viewController = SearchOptionsViewController(viewModel: viewModel)

    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let viewModel = SearchOptionsViewModelMock(state: .error("Error to Fetch Genres"), sections: [])
    let viewController = SearchOptionsViewController(viewModel: viewModel)

    viewController.overrideUserInterfaceStyle = .light

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 1, on: .image(on: .iPhoneSe)))
  }
}
