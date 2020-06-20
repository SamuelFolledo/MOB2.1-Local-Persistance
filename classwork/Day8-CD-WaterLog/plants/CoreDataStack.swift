//
//  CoreDataStack.swift
//  plants
//
//  Created by Samuel Folledo on 6/17/20.
//  Copyright © 2020 Adriana González Martínez. All rights reserved.
//

import Foundation
import CoreData //import the core data module

class CoreDataStack {
    
    //we always need this
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private let modelName: String //create a private property to store the modelName
    
    //lazy instantiate the NSPersistentContainer, passing the modelName
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores {(storeDescription, error) in
            if let error = error as NSError? {
                print("Error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName //initializer needed to save the modelName into the private property
    }
    
    func saveContext () {
      guard managedContext.hasChanges else { return }

      do {
        try managedContext.save()
      } catch let error as NSError {
        print("Error: \(error), \(error.userInfo)")
      }
    }
    
}