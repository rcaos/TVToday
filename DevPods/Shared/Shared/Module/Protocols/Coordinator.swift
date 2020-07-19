//
//  Coordinator.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/17/20.
//

import UIKit

// MARK: - Rename

public protocol NCoordinator: class {
  
  func start(with step: MyStep)
}

public extension NCoordinator {

  func start(with step: MyStep = DefaultStep() ) {
    
  }
}

public protocol NavigationCoordinator: NCoordinator {
  
  var navigationController: UINavigationController { get }
  
}

// Describe un posible State de nagevación

public protocol MyStep { }

public struct DefaultStep: MyStep {
  public init() { }
}
