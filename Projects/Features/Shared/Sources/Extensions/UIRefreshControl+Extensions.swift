//
//  UIRefreshControl+Extensions.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/20/20.
//

import UIKit

extension UIRefreshControl {

  public func endRefreshing(with delay: TimeInterval = 0.5) {
    if isRefreshing {
      perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: delay)
    }
  }
}
