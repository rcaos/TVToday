//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  let appDIContainer = AppDIContainer()
  
  var window: UIWindow?
  
  // Change "MainDIContainer" for appDIContainer
  private var dIContainer: MainDIContainer? = nil
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    dIContainer = MainDIContainer(window: window!)
    return true
  }
}

