//
//  PresentableView.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/16/20.
//

import UIKit

public protocol Retryable {
  
  func showMessageView(with message: String?, errorHandler: @escaping () -> Void)
  
  func hideMessageView()
}

// MARK: - UIViewController

public extension Retryable where Self: UIViewController {
  
  func showMessageView(with message: String?, errorHandler: @escaping () -> Void ) {
    let messageView = ErrorView.loadFromNib()
    messageView.messageLabel.text = message
    messageView.retry = errorHandler
    
    messageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(messageView)
    
    messageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    messageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    messageView.tag = ConstantsPresentable.presentableViewTag
  }
  
  func hideMessageView() {
    view.subviews.forEach { subview in
      if subview.tag == ConstantsPresentable.presentableViewTag {
        subview.removeFromSuperview()
      }
    }
  }
}

// MARK: - ConstantsLoadable

private struct ConstantsPresentable {
  fileprivate static let presentableViewTag = 1235
}
