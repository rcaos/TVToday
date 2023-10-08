//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine

protocol ProfileViewModelDelegate: AnyObject {
  func profileViewModel(didTapLogoutButton tapped: Bool)
  func profileViewModel(didUserList tapped: UserListType)
}

protocol ProfileViewModelProtocol {
  // MARK: - Input
  func didTapLogoutButton()
  func didCellTap(model: ProfilesSectionItem)
  var delegate: ProfileViewModelDelegate? { get set }

  // MARK: - Output
  var dataSource: CurrentValueSubject<[ProfileSectionModel], Never> { get }
  var presentSignOutAlert: CurrentValueSubject<Bool, Never> { get }
}
