//
//  MainTabBarViewController.swift
//  MyTvShows
//
//  Created by Jeans on 9/4/19.
//  Copyright © 2019 Jeans. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = createControllers()
        delegate = self
    }
    
    private func createControllers() -> [UIViewController] {
        
        let airingTodayVC = appDIContainer.makeTodayShowsSceneDIContainer().makeAiringTodayViewController()
        airingTodayVC.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "calendar"), tag: 0)
        let todayNavigation = UINavigationController(rootViewController: airingTodayVC)
        
        let popularVC = PopularsViewController.create(with: PopularViewModel())
        popularVC.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(named: "popular"), tag: 1)
        let popularNavigation = UINavigationController(rootViewController: popularVC)
        
        let searchVC = SearchViewController.create(with: SearchViewModel())
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let searchNavigation = UINavigationController(rootViewController: searchVC)
        
        return [todayNavigation, popularNavigation, searchNavigation]
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Selected indexTabBar: [\(selectedIndex)]")
    }
}
