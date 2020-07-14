//
//  UINavigationController+Create.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public extension UINavigationController {
  
  class func replaceAppearance() {
    
    UINavigationBar.appearance().titleTextAttributes = [
      NSAttributedString.Key.font: Font.montserrat.of(type: .bold, with: .normal),
      NSAttributedString.Key.foregroundColor: Colors.electricBlue.color
    ]
    
    UIBarButtonItem.appearance().setTitleTextAttributes([
      NSAttributedString.Key.font: Font.montserrat.of(type: .bold, with: .normal)
    ], for: .normal)
  }
}
