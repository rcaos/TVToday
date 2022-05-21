//
//  UIImageView+Kingfisher.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/25/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {

  public func setImage(with url: URL?, placeholder: UIImage? = nil) {
    kf.indicatorType = .activity
    kf.setImage(with: url, placeholder: placeholder)
  }
}
