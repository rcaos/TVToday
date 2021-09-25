//
//  AppDelegate.swift
//  MyMovies
//
//  Created by Jeans on 8/20/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit
import UI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  let appDIContainer = AppDIContainer()
  
  var appCoordinator: AppCoordinator?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
//    UIFont.loadFonts()
    UINavigationController.replaceAppearance()
    
    window = UIWindow(frame: UIScreen.main.bounds)

    appCoordinator = AppCoordinator(window: window!, appDIContainer: appDIContainer)
    appCoordinator?.start()

    return true
  }
}
