//
//  UIViewController+Extensions.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import UIKit.UIViewController
import CoreData.NSManagedObjectContext

extension UIViewController {
    
    var managedObjectContext: NSManagedObjectContext {
        return CoreDataStack.shared.managedObjectContext
    }
}
