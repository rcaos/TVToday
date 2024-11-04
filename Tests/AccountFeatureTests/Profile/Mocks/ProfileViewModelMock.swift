//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
@testable import AccountFeature

final class ProfileViewModelMock: ProfileViewModelProtocol {

  func didTapLogoutButton() { }
  func didCellTap(model: ProfilesSectionItem) { }

  weak var delegate: ProfileViewModelDelegate?

  var dataSource: Published<[ProfileSectionModel]>.Publisher { $dataSourceInternal }
  var presentSignOutAlert: Published<Bool>.Publisher { $presentSignOutAlertInternal }

  @Published private var dataSourceInternal: [ProfileSectionModel] = []
  @Published private var presentSignOutAlertInternal = false

  init(account: Account) {
    let accountSection = ProfileViewModelMock.createSectionModel(account: account)

    dataSourceInternal = accountSection
    presentSignOutAlertInternal = false
  }

  static func createSectionModel(account: Account) -> [ProfileSectionModel] {

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
