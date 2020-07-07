//
//  UIViewController+Extensions.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

extension UIViewController {
  
  public func add(asChildViewController viewController: UIViewController) {
    addChild(viewController)
    
    view.addSubview(viewController.view)
    
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    viewController.didMove(toParent: self)
  }
  
  public func add(asChildViewController viewController: UIViewController, containerView: UIView) {
    addChild(viewController)
    
    containerView.addSubview(viewController.view)
    
    viewController.view.frame = containerView.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    viewController.didMove(toParent: self)
  }
  
  public func remove(asChildViewController viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}
