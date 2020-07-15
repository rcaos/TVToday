//
//  UINavigationController+Create.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public extension UINavigationController {
  
  class func replaceAppearance() {
    
    if #available(iOS 13.0, * ) {
      let standard = UINavigationBarAppearance()
      standard.configureWithTransparentBackground()
      
      standard.titleTextAttributes = [
        .foregroundColor: Colors.electricBlue.color,
        .font: Font.montserrat.of(type: .bold, with: .normal)]
      
      let button = UIBarButtonItemAppearance(style: .plain)
      button.normal.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: Colors.electricBlue.color,
        .font: Font.montserrat.of(type: .bold, with: .normal)]
      standard.buttonAppearance = button
      
      let done = UIBarButtonItemAppearance(style: .done)
      done.normal.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: Colors.electricBlue.color,
        .font: Font.montserrat.of(type: .bold, with: .normal)]
      standard.doneButtonAppearance = done
      
      UINavigationBar.appearance().standardAppearance = standard
      
    } else {
      UINavigationBar.appearance().titleTextAttributes = [
        NSAttributedString.Key.font: Font.montserrat.of(type: .bold, with: .normal),
        NSAttributedString.Key.foregroundColor: Colors.electricBlue.color
      ]
      
      UIBarButtonItem.appearance().setTitleTextAttributes([
        NSAttributedString.Key.font: Font.montserrat.of(type: .bold, with: .normal)
      ], for: .normal)
    }
  }
}
