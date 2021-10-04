//
//  ProfileViewModelMock.swift
//  AccountTV-Unit-Tests
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift
@testable import Account

final class ProfileViewModelMock: ProfileViewModelProtocol {

  func createSectionModel(account: AccountResult) { }

  let tapCellAction = PublishSubject<ProfilesSectionItem>()

  func didTapLogoutButton() { }

  weak var delegate: ProfileViewModelDelegate?

  let dataSource: Observable<[ProfileSectionModel]>

  let presentSignOutAlert: Observable<Bool>

  init(account: AccountResult) {
    let accountSection = ProfileViewModelMock.createSectionModel(account: account)

    dataSource = Observable.just( accountSection )
    presentSignOutAlert = Observable.just(false)
  }

  static func createSectionModel(account: AccountResult) -> [ProfileSectionModel] {

    let items: [ProfilesSectionItem] = [
      .userLists(items: .favorites),
      .userLists(items: .watchList)]

    let sectionProfile: [ProfileSectionModel] = [
      .userInfo(header: "", items: [.userInfo(number: account)]),
      .userLists(header: "", items: items),
      .logout(header: "", items: [.logout(items: "Log Out")])
    ]

    return sectionProfile
  }
}
