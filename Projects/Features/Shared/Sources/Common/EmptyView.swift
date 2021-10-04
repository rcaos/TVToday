//
//  EmptyView.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/3/20.
//

import UIKit
import UI

public class EmptyView: UIView, NibLoadable {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var messageLabel: TVRegularLabel!

  override public func awakeFromNib() {
    super.awakeFromNib()
    setupView()
  }

  private func setupView() {
    backgroundColor = .white

    messageLabel.numberOfLines = 0

    // MARK: TODO, rename image
    imageView.image = UIImage(name: "Error009")
  }
}
