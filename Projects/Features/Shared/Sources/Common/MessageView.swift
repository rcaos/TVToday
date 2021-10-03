//
//  MessageView.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/27/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit
import UI

public class MessageView: UIView {

  public let messageLabel = TVRegularLabel(frame: .zero)

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  public convenience init(message: String?) {
    self.init(frame: .zero)
    messageLabel.text = message
  }

  private func setupView() {
    backgroundColor = .white
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center

    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    addSubview(messageLabel)

    messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

    messageLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8).isActive = true
    messageLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 8).isActive = true
  }
}
