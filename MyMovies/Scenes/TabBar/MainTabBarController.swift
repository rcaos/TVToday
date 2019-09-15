//
//  MainTabBarViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension MainTabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected indexTabBar: [\(selectedIndex)]")
    }
}
