//
//  UICollectionView+Extensions.swift
//  Shared
//
//  Created by Jeans Ruiz on 6/26/20.
//

import UIKit

extension UICollectionView {

  // MARK: - Register Cell
  public func registerCell<T: UICollectionViewCell>(cellType: T.Type) {
    let identifier = cellType.dequeuIdentifier
    register(cellType, forCellWithReuseIdentifier: identifier)
  }

  // MARK: - Register Nib
  public func registerNib<T: UICollectionViewCell>(cellType: T.Type, bundle: Bundle) {
    let identifier = cellType.dequeuIdentifier
    let nib = UINib(nibName: identifier, bundle: bundle)
    register(nib, forCellWithReuseIdentifier: identifier)
  }

  // MARK: - Dequeuing
  public func dequeueReusableCell<T: UICollectionViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withReuseIdentifier: type.dequeuIdentifier, for: indexPath) as! T
  }
}
