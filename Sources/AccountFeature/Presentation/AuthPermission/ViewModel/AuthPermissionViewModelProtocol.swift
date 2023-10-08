//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation

public protocol AuthPermissionViewModelDelegate: AnyObject {
  func authPermissionViewModel(didSignedIn signedIn: Bool) async
}

protocol AuthPermissionViewModelProtocol {
  func signIn() async
  var authPermissionURL: URL { get }
  var delegate: AuthPermissionViewModelDelegate? { get set }
}
