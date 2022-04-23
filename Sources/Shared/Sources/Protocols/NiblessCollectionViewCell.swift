//
//  NiblessCollectionViewCell.swift
//  Shared
//
//  Created by Jeans Ruiz on 4/10/21.
//

import UIKit

open class NiblessCollectionViewCell: UICollectionViewCell {

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  @available(*, unavailable,
  message: "Loading this view Cell from a nib is unsupported in favor of initializer dependency injection.")
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Loading this view Cell from a nib is unsupported in favor of initializer dependency injection.")
  }
}
