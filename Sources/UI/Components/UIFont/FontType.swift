//
//  FontType.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public enum FontType: String, CaseIterable {
  case
  light = "Light",
  regular = "Regular",
  medium = "Medium",
  semiBold = "SemiBold",
  bold = "Bold"

  func of(family: Font, size: FontSize = .normal) -> UIFont {
    switch self {
    case .light:
      return buildFont(family: family, name: "\(family.rawValue)-Light", size: size, weight: .light)
    case .regular:
      return buildFont(family: family, name: "\(family.rawValue)-Regular", size: size, weight: .regular)
    case .medium:
      return buildFont(family: family, name: "\(family.rawValue)-Medium", size: size, weight: .medium)
    case .semiBold:
      return buildFont(family: family, name: "\(family.rawValue)-SemiBold", size: size, weight: .semibold)
    case .bold:
      return buildFont(family: family, name: "\(family.rawValue)-Bold", size: size, weight: .bold)
    }
  }

  fileprivate func buildFont(family: Font, name: String, size: FontSize, weight: UIFont.Weight) -> UIFont {
    switch family {
    case .montserrat:
      return UIFont(name: name, size: size.value)!
    default:
      return UIFont.systemFont(ofSize: size.value, weight: weight)
    }
  }
}
