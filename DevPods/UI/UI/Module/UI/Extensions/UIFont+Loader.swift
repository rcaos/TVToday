//
//  UIFont+Loader.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import UIKit

public extension UIFont {
  
  static func loadFonts() {
    Font.allCases
      .filter { $0 != .sanFrancisco }
      .forEach { font in
        FontType.allCases.forEach { fontType in
          loadFont(with: "\(font.rawValue)-\(fontType.rawValue)")
        }
    }
  }
  
  fileprivate static func loadFont(with name: String) {
    print("Load font: [\(name)]")
    let bundle = UIModule.bundle
    let pathForResourceString = bundle.path(forResource: name, ofType: "otf")
    let fontData = NSData(contentsOfFile: pathForResourceString!)
    let dataProvider = CGDataProvider(data: fontData!)
    let fontRef = CGFont(dataProvider!)
    var errorRef: Unmanaged<CFError>?
    
    if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
      NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
    }
  }
}
