//
//  NCMainTabBarViewController.swift
//  Netflix Clone
//
//  Created by Shagara F Nasution on 11/07/23.
//

import UIKit

final class NCMainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
    }

    private func setupTabs() {
        let homeVC = NCHomeViewController()
        let upcomingVC = NCUpcomingViewController()
        let searchVC = NCSearchViewController()
        let downloadsVC = NCDownloadsViewController()
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: upcomingVC)
        let nav3 = UINavigationController(rootViewController: searchVC)
        let nav4 = UINavigationController(rootViewController: downloadsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Upcoming", image: UIImage(systemName: "play.circle"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Discover", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Downloads", image: UIImage(systemName: "arrow.down.to.line"), tag: 4)
        
        tabBar.tintColor = .label
        
        let navs = [nav1, nav2, nav3, nav4]
        
        setViewControllers(navs, animated: true)
    }
    
}
