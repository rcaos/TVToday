//
//  Emptiable.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/3/20.
//

import UIKit

public protocol Emptiable {
  
  func showEmptyView(with message: String?)
  
  func hideEmptyView()
}

// MARK: - UIViewController

public extension Emptiable where Self: UIViewController {
  
  func showEmptyView(with message: String?) {
    let emptyView = EmptyView.loadFromNib()
    emptyView.messageLabel.text = message
    emptyView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(emptyView)
    
    emptyView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    emptyView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    emptyView.tag = ConstansEmptiable.emptyViewTag
  }
  
  func hideEmptyView() {
    view.subviews.forEach { subView in
      if subView.tag == ConstansEmptiable.emptyViewTag {
        subView.removeFromSuperview()
      }
    }
  }
}

// MARK: - Constans Emptiable

private struct ConstansEmptiable {
  fileprivate static let emptyViewTag = 4321
}
