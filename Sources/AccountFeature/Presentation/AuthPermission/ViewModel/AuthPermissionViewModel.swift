//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

@MainActor
final class AuthPermissionViewModel: AuthPermissionViewModelProtocol {
  weak var delegate: AuthPermissionViewModelDelegate?

  let authPermissionURL: URL

  // MARK: - Initializer
  init(url: URL, delegate: AuthPermissionViewModelDelegate?) {
    authPermissionURL = url
    self.delegate = delegate
  }

  func signIn() async {
    await delegate?.authPermissionViewModel(didSignedIn: true)
  }
}
