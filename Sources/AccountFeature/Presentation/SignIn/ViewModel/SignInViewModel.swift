//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation
import Combine

@MainActor
class SignInViewModel: SignInViewModelProtocol {
  private let createTokenUseCase: CreateTokenUseCase

  let viewState: CurrentValueSubject<SignInViewState, Never> = .init(.initial)
  weak var delegate: SignInViewModelDelegate?

  init(createTokenUseCase: CreateTokenUseCase) {
    self.createTokenUseCase = createTokenUseCase
  }

  // MARK: - Public
  func signInDidTapped() async {
    viewState.send(.loading)
    if let url = await createTokenUseCase.execute() {
      delegate?.signInViewModel(self, didTapSignInButton: url)
    }
  }
}
