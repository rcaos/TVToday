//
//  ProfileViewModelProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift

protocol ProfileViewModelDelegate: AnyObject {
  func profileViewModel(didTapLogoutButton tapped: Bool)
  func profileViewModel(didUserList tapped: UserListType)
}

protocol ProfileViewModelProtocol {
  // MARK: - Input
  var tapCellAction: PublishSubject<ProfilesSectionItem> { get }
  func didTapLogoutButton()
  var delegate: ProfileViewModelDelegate? { get set }

  // MARK: - Output
  var dataSource: Observable<[ProfileSectionModel]> { get }
  var presentSignOutAlert: Observable<Bool> { get }
}
