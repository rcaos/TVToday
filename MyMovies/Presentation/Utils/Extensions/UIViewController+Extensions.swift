//
//  UIViewController+Extensions.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/19/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func add(asChildViewController viewController: UIViewController) {
    addChild(viewController)
    
    view.addSubview(viewController.view)
    
    viewController.view.frame = view.bounds
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    viewController.didMove(toParent: self)
  }
  
  func remove(asChildViewController viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}
