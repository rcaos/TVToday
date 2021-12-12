//
//  Colors.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public enum Colors {
  case customGreen

  public var color: UIColor {
    switch self {
    case .customGreen:
      return UIColor(name: "Custom-Green")
    }
  }
}
