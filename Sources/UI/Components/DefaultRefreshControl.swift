//
//  DefaultRefreshControl.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/20/20.
//

import UIKit

public class DefaultRefreshControl: UIRefreshControl {

  var refreshHandler: () -> Void

  // MARK: - Initializer
  public init(tintColor: UIColor = .systemBlue,
              attributedTitle: String = "",
              backgroundColor: UIColor? = .clear,
              refreshHandler: @escaping () -> Void) {
    self.refreshHandler = refreshHandler
    super.init()
    self.tintColor = tintColor
    self.backgroundColor = backgroundColor
    self.attributedTitle = NSAttributedString(
      string: attributedTitle,
      attributes: [
        NSAttributedString.Key.font: UIFont.app_caption1(),
        NSAttributedString.Key.foregroundColor: tintColor
      ]
    )
    addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  @objc func refreshControlAction() {
    refreshHandler()
  }
}
