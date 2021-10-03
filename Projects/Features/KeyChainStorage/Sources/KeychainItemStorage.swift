//
//  KeychainItemStorage.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/21/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import Foundation
import KeychainSwift

@propertyWrapper
struct KeychainItemStorage {

  private let key: String
  private lazy var keychain = KeychainSwift()

  init(key: String) {
    self.key = key
  }

  var wrappedValue: String? {
    mutating get {
      return keychain.get(key)
    }
    set {
      if let newValue = newValue {
        keychain.set(newValue, forKey: key)
      } else {
        keychain.delete(key)
      }
    }
  }
}
