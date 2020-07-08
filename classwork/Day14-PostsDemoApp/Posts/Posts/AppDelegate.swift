//
//  AppDelegate.swift
//  News
//
//  Created by Mustafa on 05/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { _, _ in }
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    //MARK:- UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, Cloud {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        guard let notification = CKNotification(fromRemoteNotificationDictionary: userInfo) else {
            completionHandler(.noData)
            return
        }
        
        switch notification.notificationType {
            
        case .database:
            guard let databaseNotification = CKDatabaseNotification(fromRemoteNotificationDictionary: userInfo) else {
                completionHandler(.noData)
                return
            }
            
            switch databaseNotification.databaseScope {
            case .private:
                fetchUpdates(managedObjectContext: CoreDataStack.shared.managedObjectContext)
                completionHandler(.newData)
            case .public:
                completionHandler(.noData)
            default:
                completionHandler(.noData)
            }
            
        case .query:
            guard let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo),
            let recordID = queryNotification.recordID else {
                completionHandler(.noData)
                return
            }
            fetchPosts(with: [recordID], managedObjectContext: CoreDataStack.shared.managedObjectContext)
        default:
            completionHandler(.noData)
        }
    }
}

