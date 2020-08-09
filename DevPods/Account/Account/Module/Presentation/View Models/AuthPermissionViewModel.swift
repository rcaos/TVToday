//
//  AuthPermissionViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import RxSwift

final class AuthPermissionViewModel: AuthPermissionViewModelProtocol {
  
  weak var delegate: AuthPermissionViewModelDelegate?
  
  let didSignIn = PublishSubject<Bool>()
  
  let authPermissionURL: URL
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init(url: URL) {
    authPermissionURL = url
    subscribe()
  }
  
  func signIn() {
    didSignIn.onNext(true)
  }
  
  fileprivate func subscribe() {
    didSignIn.asObserver()
      .subscribe(onNext: { [weak self] signedIn in
        self?.delegate?.authPermissionViewModel(didSignedIn: signedIn)
      })
      .disposed(by: disposeBag)
  }
}
