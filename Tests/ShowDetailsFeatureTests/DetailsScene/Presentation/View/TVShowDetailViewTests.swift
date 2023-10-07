//
//  TVShowDetailViewTests.swift
//  ShowDetailsTests
//
//  Created by Jeans Ruiz on 19/12/21.
//

import SnapshotTesting
import XCTest

@testable import ShowDetailsFeature
@testable import Shared
import UI

class TVShowDetailViewTests: XCTestCase {

  override class func setUp() {
    Strings.currentLocale = Locale(identifier: Language.en.rawValue)
  }

  override func setUp() {
    super.setUp()
    defaultScheduler = .immediate
    isRecording = false
  }

  func test_WhenViewIsLoading_thenShowLoadingScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .loading)

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewPopulated_thenShowPopulatedScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .populated( TVShowDetailInfo.stub() ))

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }

  func test_WhenViewIsError_thenShowErrorScreen() {
    // given
    let initialState = TVShowDetailViewModelMock(state: .error("Error to Fetch Details"))

    // when
    let viewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(viewController, style: .dark)

    // then
    assertSnapshot(of: viewController, as: .image(on: .iPhoneSe, precision: 0.99))

    // when
    let lightViewController = TVShowDetailViewController(viewModel: initialState)
    configureWith(lightViewController, style: .light)

    // then
    assertSnapshot(of: lightViewController, as: .image(on: .iPhoneSe, precision: 0.99))
  }
}
