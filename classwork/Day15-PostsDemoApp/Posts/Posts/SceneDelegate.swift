//
//  SceneDelegate.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate, Cloud {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = TabController()
            self.window = window
            window.makeKeyAndVisible()
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        let managedObjectContext = CoreDataStack.shared.managedObjectContext
        try? managedObjectContext.save()
        syncFavorites(managedObjectContext: managedObjectContext)
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        fetchUpdates(managedObjectContext: CoreDataStack.shared.managedObjectContext)
    }
}
