//
//  Coordinator.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/17/20.
//

import UIKit

public protocol Coordinator: class {
  
  func start(with step: Step)
  
  func start()
}

public extension Coordinator {

  func start(with step: Step = DefaultStep() ) { }
  
  func start() { }
}

public protocol NavigationCoordinator: Coordinator {
  
  var navigationController: UINavigationController { get }
  
}

// MARK: - Step Protocol

/// Describe un posible estado de navegación dentro de un Coordinator

public protocol Step { }

public struct DefaultStep: Step {
  public init() { }
}
