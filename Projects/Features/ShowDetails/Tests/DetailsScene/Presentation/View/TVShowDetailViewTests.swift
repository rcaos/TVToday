//
//  TVShowDetailViewTests.swift
//  ShowDetailsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import SnapshotTesting
import XCTest

@testable import ShowDetails
@testable import Shared

class TVShowDetailViewTests: XCTestCase {

  override func setUp() {
    super.setUp()
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .loading)

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .populated( TVShowDetailInfo.stub() ))

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneXsMax)))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .error("Error to Fetch Details"))

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(matching: viewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(matching: lightViewController, as: .wait(for: 0.01, on: .image(on: .iPhoneSe)))
  }
}
