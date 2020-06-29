//
//  Loadable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

protocol Loadable {
  func showLoadingView()
  func hideLoadingView()
}

// MARK: - UIButton

extension Loadable where Self: UIButton {
  
  func showLoadingView() {
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    activityIndicator.startAnimating()
    activityIndicator.tag = 1234
    
    isUserInteractionEnabled = false
  }
  
  func hideLoadingView() {
    subviews.forEach { subview in
      if subview.tag == 1234 {
        subview.removeFromSuperview()
      }
    }
    isUserInteractionEnabled = true
  }
}
