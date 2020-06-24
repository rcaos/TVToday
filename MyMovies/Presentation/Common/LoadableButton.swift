//
//  LoadableButton.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class LoadableButton: UIButton, Loadable {
  
  var defaultTitle: String? = ""
  
  func defaultShowLoadingView() {
    (self as Loadable).showLoadingView()
    setTitle("", for: .normal)
  }
  
  func defaultHideLoadingView() {
    (self as Loadable).hideLoadingView()
    setTitle(defaultTitle, for: .normal)
  }
}
