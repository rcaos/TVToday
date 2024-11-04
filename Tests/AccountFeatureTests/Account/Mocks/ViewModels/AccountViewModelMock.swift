//
//  Created by Jeans Ruiz on 8/8/20.
//

import Combine
@testable import AccountFeature

final class AccountViewModelMock: AccountViewModelProtocol {

  func viewDidLoad() async { }

  @Published private var viewStateInternal = AccountViewState.login
  var viewState: Published<AccountViewState>.Publisher { $viewStateInternal }

  init(state: AccountViewState) {
    viewStateInternal = state
  }

  func authPermissionViewModel(didSignedIn signedIn: Bool) { }
}
