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

    // MARK: - TODO, check this
//
//    let button = UIBarButtonItemAppearance(style: .plain)
//    button.normal.titleTextAttributes = [
//      NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
//      .font: Font.sanFrancisco.of(type: .bold, with: .normal)]
//    standard.buttonAppearance = button
//
//    let done = UIBarButtonItemAppearance(style: .done)
//    done.normal.titleTextAttributes = [
//      NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
//      .font: Font.sanFrancisco.of(type: .bold, with: .normal)]
//    standard.doneButtonAppearance = done

    UINavigationBar.appearance().standardAppearance = standard
  }
}
