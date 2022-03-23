//
//  SignInViewModelProtocol.swift
//  AccountTV
//
//  Created by Jeans Ruiz on 8/8/20.
//

import Foundation
import Combine
import RxSwift

protocol SignInViewModelDelegate: AnyObject {
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton url: URL)
}

protocol SignInViewModelProtocol {
  // MARK: - Input
  func signInDidTapped()
  func changeState(with state: SignInViewState)

  // MARK: - Output
  var viewState: Observable<SignInViewState> { get }
  var delegate: SignInViewModelDelegate? { get set }
}

// MARK: - View State
enum SignInViewState: Equatable {
  case initial
  case loading
  case error
}
