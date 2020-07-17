//
//  Coordinator.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/17/20.
//

import UIKit

//Coordinator = FlowCoordinator

public protocol FCoordinator: class {
  
  var childCoordinators: [FCoordinator] { get set }
  
  var parentCoordinator: FCoordinator? { get set }
  
  var root: FPresentable { get }
  
  func start()
  
  func childDidFinish(_ child: FCoordinator)
}

public extension FCoordinator {
  
  var unwrappedParentCoordinator: FCoordinator {
    return parentCoordinator ?? self
  }
  
  // MARK: - TODO, iterare reverse??
  
  func childDidFinish(_ child: FCoordinator) {
    for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
      childCoordinators.remove(at: index)
      break
    }
  }
  
  // MARK: - TODO
//  func childDidFinish() {
//    childCoordinators.removeLast()
//  }
  
}

public protocol FPresentable { }

//public extension FPresentable where Self: UINavigationController { }

//public extension FPresentable where Self: UIViewController { }

extension UIViewController: FPresentable { }

//extension UINavigationController: FPresentable { }
//
//extension UITabBarController: FPresentable { }
