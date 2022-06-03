//
//  Dequeuable.swift
//  Shared
//
//  Created by Jeans Ruiz on 6/26/20.
//

import UIKit

public protocol Dequeuable {
  static var dequeuIdentifier: String { get }
}

extension Dequeuable where Self: UIView {
  public static var dequeuIdentifier: String {
    return String(describing: self)
  }

}

extension UITableViewCell: Dequeuable { }

extension UICollectionViewCell: Dequeuable { }
