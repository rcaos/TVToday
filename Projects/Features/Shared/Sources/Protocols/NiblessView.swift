//
//  NiblessView.swift
//  Shared
//
//  Created by Jeans Ruiz on 8/21/20.
//

import UIKit

open class NiblessView: UIView {

  // MARK: - Methods
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable,
  message: "Loading this view from a nib is unsupported in favor of initializer dependency injection."
  )

  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view from a nib is unsupported in favor of initializer dependency injection.")
  }
}
