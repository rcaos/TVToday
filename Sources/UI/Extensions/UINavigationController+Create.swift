//
//  UINavigationController+Create.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public extension UINavigationController {

  class func replaceAppearance() {
    let standard = UINavigationBarAppearance()
    standard.configureWithDefaultBackground()

    standard.titleTextAttributes = [
      .foregroundColor: UIColor.systemBlue,
      .font: UIFont.app_title3().bolded.designed(.rounded)
    ]

    UINavigationBar.appearance().standardAppearance = standard
  }
}
