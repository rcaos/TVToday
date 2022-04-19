//
//  ProfileViewModelTests.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
import XCTest
@testable import Account
@testable import Shared

class ProfileViewModelTests: XCTestCase {

  private var disposeBag: Set<AnyCancellable>!

  override func setUp() {
    super.setUp()
    disposeBag = []
  }

  func test_When_User_Is_Logged_Should_Contains_Sections_On_DataSource() {
    // given
    let accountResult = AccountResult.stub(hash: "", id: 1, userName: "UserName")
    let sut: ProfileViewModelProtocol = ProfileViewModel(account: accountResult)

    // when
    let expected = [createSectionModel(with: accountResult)]
    var received = [[ProfileSectionModel]]()

    sut.dataSource.removeDuplicates()
      .sink(receiveValue: { received.append($0) }).store(in: &disposeBag)

    // then
    XCTAssertEqual(expected, received, "Should only receives one Value")
  }
}

// MARK: - Helpers
private func createSectionModel(with account: AccountResult) -> [ProfileSectionModel] {
  let items: [ProfilesSectionItem] = [
    .userLists(items: .favorites),
    .userLists(items: .watchList)
  ]

  let sectionProfile: [ProfileSectionModel] = [
    .userInfo(items: [.userInfo(number: account)]),
    .userLists(items: items),
    .logout(items: [.logout(items: "Log Out")])
  ]
  return sectionProfile
}
