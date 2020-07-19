//
//  Coordinator.swift
//  Shared
//
//  Created by Jeans Ruiz on 7/17/20.
//

import UIKit

// MARK: - Rename

public protocol NCoordinator: class {
  
  func start()
  
}

public protocol NavigationCoordinator: NCoordinator {
  
  var navigationController: UINavigationController { get }
  
}
