//
//  Font.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public enum Font: String, CaseIterable {

  case montserrat = "Montserrat"
  case sanFrancisco = "SFProText"

  var resourceName: String {
    switch self {
    case .montserrat:
      return "Montserrat"
    case .sanFrancisco:
      return "SFProText"
    }
  }

  public init() {
    self = .sanFrancisco
  }

  public func of(type: FontType, with size: FontSize) -> UIFont {
    return type.of(family: self, size: size)
  }
}
