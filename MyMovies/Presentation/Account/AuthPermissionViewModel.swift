//
//  AuthPermissionViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxFlow
import RxRelay
import RxSwift

protocol AuthPermissionViewModelDelegate: class {
  
  func authPermissionViewModel(didSignedIn signedIn: Bool)
}

final class AuthPermissionViewModel {
  
  weak var delegate: AuthPermissionViewModelDelegate?
  
  var input: Input
  
  var output: Output
  
  private let disposeBag = DisposeBag()
  
  init(url: URL) {
    input = Input()
    output = Output(authPermissionURL: url)
    
    subscribe()
  }
  
  fileprivate func subscribe() {
    input.didSignIn.asObserver()
      .subscribe(onNext: { [weak self] signedIn in
        self?.delegate?.authPermissionViewModel(didSignedIn: signedIn)
      })
      .disposed(by: disposeBag)
  }
}

extension AuthPermissionViewModel {
  
  public struct Input {
    let didSignIn = PublishSubject<Bool>()
  }
  
  public struct Output {
    let authPermissionURL: URL
  }
}
