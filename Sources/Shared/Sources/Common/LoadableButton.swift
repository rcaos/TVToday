//
//  LoadableButton.swift
//  TVToday
//
//  Created by Jeans Ruiz on 6/22/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public class LoadableButton: UIButton, Loadable {

  public var defaultTitle: String? = ""

  public func defaultShowLoadingView() {
    (self as Loadable).showLoadingView()
    setTitle("", for: .normal)
  }

  public func defaultHideLoadingView() {
    (self as Loadable).hideLoadingView()
    setTitle(defaultTitle, for: .normal)
  }
}
