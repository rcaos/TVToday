//
//  LoadingView.swift
//  TVToday
//
//  Created by Jeans Ruiz on 3/26/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
  
  public static var defaultView: LoadingView = {
    let recommendedFrame: CGRect = CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: 100)
    let defaultLoadingView = LoadingView(frame: recommendedFrame)
    return defaultLoadingView
  }()
  
  private let activityIndicator = UIActivityIndicatorView(style: .gray)
  
  // MARK: - Initializers
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupView() {
    backgroundColor = .white
    activityIndicator.color = .darkGray
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    
    activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    activityIndicator.startAnimating()
  }
}
