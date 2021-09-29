//
//  UITableView+Extensions.swift
//  Shared
//
//  Created by Jeans Ruiz on 6/26/20.
//

import UIKit

extension UITableView {
  
  // MARK: - Register Cell
  
  public func registerCell<T: UITableViewCell>(cellType: T.Type) {
    let identifier = cellType.dequeuIdentifier
    register(cellType, forCellReuseIdentifier: identifier)
  }
  
  // MARK: - Register Nib
  
  public func registerNib<T: UITableViewCell>(cellType: T.Type, bundle: Bundle) {
    let identifier = cellType.dequeuIdentifier
    let nib = UINib(nibName: identifier, bundle: bundle)
    register(nib, forCellReuseIdentifier: identifier)
  }
  
  // MARK: - Dequeing
  
  public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
    return self.dequeueReusableCell(withIdentifier: type.dequeuIdentifier, for: indexPath) as! T
  }
}
