//
//  Created by Jeans Ruiz on 6/19/20.
//

import Foundation

@MainActor
class SignInViewModel: SignInViewModelProtocol {
  private let createTokenUseCase: CreateTokenUseCase

  @Published private var viewStateInternal: SignInViewState = .initial
  public var viewState: Published<SignInViewState>.Publisher { $viewStateInternal }

  weak var delegate: SignInViewModelDelegate?

  init(createTokenUseCase: CreateTokenUseCase) {
    self.createTokenUseCase = createTokenUseCase
  }

  // MARK: - Public
  func signInDidTapped() async {
    viewStateInternal = .loading
    if let url = await createTokenUseCase.execute() {
      delegate?.signInViewModel(self, didTapSignInButton: url)
    }
  }
}
