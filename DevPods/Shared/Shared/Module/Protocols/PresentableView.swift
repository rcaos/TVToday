//
//  PresentableView.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/16/20.
//

import UIKit

public protocol PresentableView {
  
  func showMessageView(with message: String?)
  
  func hideMessageView()
}

// MARK: - UIViewController

public extension PresentableView where Self: UIViewController {
  
  func showMessageView(with message: String?) {
    let messageView = MessageView(message: message)
    
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
