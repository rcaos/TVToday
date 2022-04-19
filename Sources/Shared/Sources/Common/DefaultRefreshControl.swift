//
//  DefaultRefreshControl.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/20/20.
//

import UIKit
import UI

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
    self.attributedTitle = NSAttributedString(string: attributedTitle,
                                              attributes: [NSAttributedString.Key.font: Font.sanFrancisco.of(type: .light, with: .custom(12)),
                                                           NSAttributedString.Key.foregroundColor: tintColor])
    addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError()
  }

  // MARK: - Selectors
  @objc func refreshControlAction() {
    refreshHandler()
  }
}
