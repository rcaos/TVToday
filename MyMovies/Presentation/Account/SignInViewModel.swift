//
//  SignInViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import RxSwift
import RxFlow
import RxRelay

protocol SignInViewModelDelegate: class {
  
  func signInViewModel(_ signInViewModel: SignInViewModel, didTapSignInButton tapped: Bool)
}

class SignInViewModel {
  
  weak var delegate: SignInViewModelDelegate?
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  
  init() {
    input = Input()
    output = Output()
    
    subscribe()
  }
  
  fileprivate func subscribe() {
    input.tapButton.asObserver()
      .subscribe(onNext: { [weak self] in
        guard let strongSelf = self else { return }
        strongSelf.delegate?.signInViewModel(strongSelf, didTapSignInButton: true)
      })
      .disposed(by: disposeBag)
  }
  
}

extension SignInViewModel {
  
  public struct Input {
    let tapButton = PublishSubject<Void>()
  }
  
  public struct Output { }
}
