//
//  ErrorView.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/2/20.
//

import UIKit
import UI

public class ErrorView: UIView, NibLoadable {
  
  @IBOutlet weak var titleLabel: TVBoldLabel!
  @IBOutlet weak var messageLabel: TVRegularLabel!
  @IBOutlet weak var retryButton: LoadableButton!
  
  var retry: (() -> Void)?
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }
    
  private func setupView() {
    backgroundColor = .white
    
    titleLabel.tvSize = .custom(25)
    messageLabel.numberOfLines = 0
    
    retryButton.setTitle("Retry", for: .normal)
    retryButton.defaultTitle = "Retry"
    retryButton.backgroundColor = Colors.electricBlue.color
    retryButton.setTitleColor(.white, for: .normal)
    retryButton.titleLabel?.font = Font.sanFrancisco.of(type: .regular, with: .normal)
    
    retryButton.contentEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 15)
    
    retryButton.layer.cornerRadius = 5
    
    retryButton.addTarget(self, action: #selector(retryAction), for: .touchUpInside)
  }
  
  @objc private func retryAction() {
    retryButton.defaultShowLoadingView()
    retry?()
  }
  
  func resetState() {
    retryButton.defaultHideLoadingView()
  }
}
