//
//  UIModule.swift
//  UI
//
//  Created by Jeans Ruiz on 7/13/20.
//

import Foundation


// MARK: - TODO

//internal class UIModule {
//  static let bundle = Bundle(for: UIModule.self)
//}




// swiftlint:disable all
// swift-format-ignore-file
// swiftformat:disable all
import Foundation

// MARK: - Swift Bundle Accessor

private class BundleFinder {}

//extension Foundation.Bundle {
//    /// Since UI is a static library, the bundle for classes within this module can be used directly.
//    static var module: Bundle = {
//        let bundleName = "UIResources"
//
//        let candidates = [
//            Bundle.main.resourceURL,
//            Bundle(for: BundleFinder.self).resourceURL,
//            Bundle.main.bundleURL,
//        ]
//
//        for candidate in candidates {
//            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
//            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
//                return bundle
//            }
//        }
//        fatalError("unable to find bundle named UIResources")
//    }()
//}

// MARK: - Objective-C Bundle Accessor

@objc
public class UIResources: NSObject {
   @objc public class var bundle: Bundle {
         return .module
   }
}
// swiftlint:enable all
// swiftformat:enable all
