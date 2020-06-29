//
//  StoryboardInstantiable.swift
//  TVToday
//
//  Created by Jeans Ruiz on 1/14/20.
//  Copyright © 2020 Jeans. All rights reserved.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
  associatedtype ViewControllerType
  static var defaultFileName: String { get }
  static func instantiateViewController() -> ViewControllerType
}

public extension StoryboardInstantiable where Self: UIViewController {
  
  static var defaultFileName: String {
    return NSStringFromClass(Self.self).components(separatedBy: ".").last!
  }
  
  static func instantiateViewController() -> Self {
    let fileName = defaultFileName
    let defaultBundle = Bundle(for: Self.self)
    let storyboard = UIStoryboard(name: fileName, bundle: defaultBundle)
    guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
      fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
    }
    return viewController
  }
  
  static func instantiateViewController(fromStoryBoard storyBoard: String) -> Self {
    let identifier = defaultFileName
    let defaultBundle = Bundle(for: Self.self)
    let storyboard = UIStoryboard(name: storyBoard, bundle: defaultBundle)
    guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
      fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(identifier)")
    }
    return viewController
  }
}
