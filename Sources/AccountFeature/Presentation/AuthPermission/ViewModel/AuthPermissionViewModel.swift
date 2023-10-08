//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

final class AuthPermissionViewModel: AuthPermissionViewModelProtocol {
  weak var delegate: AuthPermissionViewModelDelegate?

  let authPermissionURL: URL

  // MARK: - Initializer
  init(url: URL) {
    authPermissionURL = url
  }

  func signIn() async {
    await delegate?.authPermissionViewModel(didSignedIn: true)
  }
}
