//
//  ProfileViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import AccountFeature

final class ProfileViewModelMock: ProfileViewModelProtocol {

  func didTapLogoutButton() { }
  func didCellTap(model: ProfilesSectionItem) { }

  weak var delegate: ProfileViewModelDelegate?
  let dataSource: CurrentValueSubject<[ProfileSectionModel], Never>
  let presentSignOutAlert: CurrentValueSubject<Bool, Never>

  init(account: AccountResult) {
    let accountSection = ProfileViewModelMock.createSectionModel(account: account)

    dataSource = CurrentValueSubject(accountSection)
    presentSignOutAlert = CurrentValueSubject(false)
  }

  static func createSectionModel(account: AccountResult) -> [ProfileSectionModel] {

    let items: [ProfilesSectionItem] = [
      .userLists(items: .favorites),
      .userLists(items: .watchList)]

    let sectionProfile: [ProfileSectionModel] = [
      .userInfo(items: [.userInfo(number: account)]),
      .userLists(items: items),
      .logout(items: [.logout(items: "Log Out")])
    ]

    return sectionProfile
  }
}
