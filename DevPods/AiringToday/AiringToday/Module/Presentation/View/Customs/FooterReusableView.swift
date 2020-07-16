//
//  FooterReusableView.swift
//  TVToday
//
//  Created by Jeans on 10/17/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import Foundation
import UIKit
import Shared

class FooterReusableView: UICollectionReusableView, Loadable {
  
  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  // MARK: - Private
  
  private func setupUI() {
    (self as Loadable).showLoadingView()
  }
}
