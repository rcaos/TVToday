//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
@testable import AccountFeature

final class SignInViewModelMock: SignInViewModelProtocol {
  func signInDidTapped() { }
  func changeState(with state: SignInViewState) { }

  @Published private var viewStateInternal: SignInViewState = .initial
  public var viewState: Published<SignInViewState>.Publisher { $viewStateInternal }

  weak var delegate: SignInViewModelDelegate?

  init(state: SignInViewState) {
    viewStateInternal = state
  }
}
