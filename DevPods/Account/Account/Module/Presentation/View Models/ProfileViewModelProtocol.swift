//
//  ProfileViewModelProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/8/20.
//

import RxSwift

protocol ProfileViewModelDelegate: class {
  
  func profileViewModel(didTapLogoutButton tapped: Bool)
  
  func profileViewModel(didUserList tapped: UserListType)
}

// MARK: - Move to another file

protocol ProfileViewModelProtocol {
  
  // MARK: - Input
  
  var tapCellAction: PublishSubject<ProfilesSectionItem> { get }
  
  func didTapLogoutButton()
  
  func createSectionModel(account: AccountResult)
  
  var delegate: ProfileViewModelDelegate? { get set }
  
  // MARK: - Output
  
  var dataSource: Observable<[ProfileSectionModel]> { get }
  
  var presentSignOutAlert: Observable<Bool> { get }
}
