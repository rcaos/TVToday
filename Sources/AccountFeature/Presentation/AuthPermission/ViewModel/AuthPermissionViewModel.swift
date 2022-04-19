//
//  AuthPermissionViewModel.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import Combine

final class AuthPermissionViewModel: AuthPermissionViewModelProtocol {
  weak var delegate: AuthPermissionViewModelDelegate?
  private let didSignIn = PassthroughSubject<Bool, Never>()
  let authPermissionURL: URL
  private var disposeBag = Set<AnyCancellable>()

  // MARK: - Initializer
  init(url: URL) {
    authPermissionURL = url
    subscribe()
  }

  func signIn() {
    didSignIn.send(true)
  }

  private func subscribe() {
    didSignIn
      .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] signedIn in
        self?.delegate?.authPermissionViewModel(didSignedIn: signedIn)
      })
      .store(in: &disposeBag)
  }
}
