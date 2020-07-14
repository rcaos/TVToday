//
//  FontSize.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public enum FontSize {
  
  case
  
  normal,
  
  custom(CGFloat)
  
  var value: CGFloat {
    switch self {
    case .normal:
      return 17.0
    case .custom(let size):
      return size
    }
    
  }
}
