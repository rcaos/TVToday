//
//  ProfileViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Combine

class ProfileViewModel: ProfileViewModelProtocol {
  weak var delegate: ProfileViewModelDelegate?

  // MARK: - Public Api
  let tapCellAction = PassthroughSubject<ProfilesSectionItem, Never>()
  let dataSource = CurrentValueSubject<[ProfileSectionModel], Never>([])
  let presentSignOutAlert = CurrentValueSubject<Bool, Never>(false)
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(account: AccountResult) {
    let section = createSectionModel(account: account)
    dataSource.send(section)
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
      presentSignOutAlert.send(true)
    default:
      break
    }
  }

  // MARK: - Private
  private func createSectionModel(account: AccountResult) -> [ProfileSectionModel] {
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
