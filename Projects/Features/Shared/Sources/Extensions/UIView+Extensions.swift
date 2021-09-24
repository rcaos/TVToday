//
//  UIView+Extensions.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/22/20.
//

import UIKit

extension UIView {
  
  public func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
      bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom),
      leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
      trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right)
    ])
  }
}
