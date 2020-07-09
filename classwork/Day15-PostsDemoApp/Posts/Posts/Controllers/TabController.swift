//
//  TabController.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = .systemPink
        
        let homeController = HomeViewController()
        homeController.tabBarItem = UITabBarItem(
            title: "Posts",
            image: UIImage(systemName: "rectangle.3.offgrid.fill"),
            selectedImage: nil
        )

        let favoriteController = FavoritesController()
        favoriteController.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart.fill"),
            selectedImage: nil
        )
        
        setViewControllers([
            UINavigationController(rootViewController: homeController),
            UINavigationController(rootViewController: favoriteController)
        ], animated: true)
    }
}
