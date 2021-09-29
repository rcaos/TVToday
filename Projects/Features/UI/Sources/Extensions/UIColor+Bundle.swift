//
//  UIColor+Bundle.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

extension UIColor {
  convenience init(name: String) {
    self.init(named: name, in: UIResources.bundle, compatibleWith: nil)!
  }
}
