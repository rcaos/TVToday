//
//  Colors.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public enum Colors {
  case customYellow
  case customGreen
  case davyGrey
  case clear

  public var color: UIColor {
    switch self {
    case .customYellow:
      return UIColor(name: "Custom-Yellow")
    case .customGreen:
      return UIColor(name: "Custom-Green")
    case .davyGrey:
      return UIColor(name: "Davy-Grey")
    case .clear:
      return UIColor.clear
    }
  }
}
