//
//  UIImage+Loader.swift
//  Account
//
//  Created by Jeans Ruiz on 6/26/20.
//

import UIKit

public extension UIImage {

  convenience init?(name: String) {
    self.init(named: name, in: Bundle.module, compatibleWith: .none)
  }
}
