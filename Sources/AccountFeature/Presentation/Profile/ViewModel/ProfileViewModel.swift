//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

class ProfileViewModel: ProfileViewModelProtocol {
  weak var delegate: ProfileViewModelDelegate?

  // MARK: - Public Api
  @Published private var dataSourceInternal: [ProfileSectionModel] = []
  var dataSource: Published<[ProfileSectionModel]>.Publisher { $dataSourceInternal }

  @Published private var presentSignOutAlertInternal = false
  var presentSignOutAlert: Published<Bool>.Publisher { $presentSignOutAlertInternal }

  // MARK: - Initializer
  init(account: Account) {
    let section = createSectionModel(account: account)
    dataSourceInternal = section
  }

  // MARK: - Public
  func didTapLogoutButton() {
    delegate?.profileViewModel(didTapLogoutButton: true)
  }

  func didCellTap(model: ProfilesSectionItem) {
    switch model {
    case .userLists(items: let cellType):
      delegate?.profileViewModel(didUserList: cellType)
    case .logout:
      presentSignOutAlertInternal = true
    default:
      break
    }
  }

  // MARK: - Private
  private func createSectionModel(account: Account) -> [ProfileSectionModel] {
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
}
