//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Combine

protocol SignInViewModelDelegate: AnyObject {
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton url: URL)
}

protocol SignInViewModelProtocol {
  // MARK: - Input
  func signInDidTapped() async

  // MARK: - Output
  var viewState: CurrentValueSubject<SignInViewState, Never> { get }
  var delegate: SignInViewModelDelegate? { get set }
}

// MARK: - View State
enum SignInViewState: Equatable {
  case initial
  case loading
  case error
}
