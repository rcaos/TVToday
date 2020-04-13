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
  
  var window: UIWindow?
  
  private var appDIContainer: AppDIContainer?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    
    appDIContainer = AppDIContainer(window: window!)
    
    return true
  }
}
