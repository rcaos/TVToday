//
//  MessageImageView.swift
//  TVToday
//
//  Created by Jeans Ruiz on 4/1/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public class MessageImageView: UIView {
  
  let stackView = UIStackView(frame: .zero)
  let imageView = UIImageView(frame: .zero)
  let messageLabel = UILabel(frame: .zero)
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  public convenience init(message: String?, image: String) {
    self.init(frame: .zero)
    messageLabel.text = message
    imageView.image = UIImage(name: image)
  }
  
  fileprivate func setupView() {
    setupElements()
    setupConstrains()
  }
  
  fileprivate func setupElements() {
    backgroundColor = .white
    
    messageLabel.numberOfLines = 0
    messageLabel.textAlignment = .center
    
    imageView.contentMode = .scaleAspectFit
    
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .fillEqually
  }
  
  fileprivate func setupConstrains() {
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(messageLabel)
    
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)
    
    stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
  }
}
