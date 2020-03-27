//
//  MessageView.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

class MessageView: UIView {
  
  let messageLabel = UILabel(frame: .zero)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  convenience init(message: String?) {
    self.init(frame: .zero)
    messageLabel.text = message
  }
  
  func setupView() {
    backgroundColor = .white
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(messageLabel)
    
    messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
  }
}
