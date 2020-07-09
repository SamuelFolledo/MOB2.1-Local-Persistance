//
//  Cloud.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit
import CoreData

protocol Cloud: class { }

extension Cloud {
    
    func fetchCategories(_ cursor: CKQueryOperation.Cursor?, managedObjectContext: NSManagedObjectContext, completionHandler: (() -> Void)? = nil) {
        subscribeToNotifcations()
        subscribeToPrivateDatabaseNotifications()
        #warning("step 1:- fetch all existing categories")
        
        var fetchedCategoryRecords: [CKRecord] = []

        let operation: CKQueryOperation

        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let query = CKQuery(recordType: CKRecord.RecordType.Category, predicate: NSPredicate(value: true))
            operation = CKQueryOperation(query: query)
        }

        operation.queryCompletionBlock = { [weak self] cursor, error in
            managedObjectContext.perform { [weak self] in
                self?.saveCategories(records: fetchedCategoryRecords, managedObjectContext: managedObjectContext)
            }

            self?.diagnoseError(error: error)

            if let cursor = cursor {
                self?.fetchCategories(cursor, managedObjectContext: managedObjectContext)
            }
            completionHandler?()
        }

        operation.recordFetchedBlock = { record in
            fetchedCategoryRecords.append(record)
        }

        CKContainer.shared.publicCloudDatabase.add(operation)
    }
    
    func fetchPosts(cursor: CKQueryOperation.Cursor?, for categories: [Category], managedObjectContext: NSManagedObjectContext) {
        
        #warning("step 2:- fetch posts for specified [Category]")
        
        var fetchedPostRecords: [CKRecord] = []

        let operation: CKQueryOperation

        if let cursor = cursor {
            operation = CKQueryOperation(cursor: cursor)
        } else {
            let predicate = NSPredicate(format: "ANY categories IN %@", categories.map { $0.recordID })
            let query = CKQuery(recordType: CKRecord.RecordType.Post, predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            operation = CKQueryOperation(query: query)
        }

        operation.resultsLimit = 4 * categories.count

        operation.queryCompletionBlock = { [weak self] cursor, error in
            managedObjectContext.perform { [weak self] in
                self?.savePosts(records: fetchedPostRecords, managedObjectContext: managedObjectContext)
            }

            self?.diagnoseError(error: error)

            if let cursor = cursor {
                self?.fetchPosts(cursor: cursor, for: categories, managedObjectContext: managedObjectContext)
            }
        }

        operation.recordFetchedBlock = { record in
            fetchedPostRecords.append(record)
        }

        CKContainer.shared.publicCloudDatabase.add(operation)
    }
    
    func fetchAllPosts(for category: Category, managedObjectContext: NSManagedObjectContext, completionHandler: (() -> Void)? = nil) {
        
        #warning("step 9:- fetch all posts that satisfy a query")
        
        var fetchedCategoryRecords: [CKRecord] = []

        let operation: CKQueryOperation

        let query = CKQuery(recordType: CKRecord.RecordType.Post, predicate: NSPredicate(format: "categories contains %@", category.recordID))
        operation = CKQueryOperation(query: query)

        operation.queryCompletionBlock = { [weak self] cursor, error in
            managedObjectContext.perform { [weak self] in
                self?.saveCategories(records: fetchedCategoryRecords, managedObjectContext: managedObjectContext)
            }

            self?.diagnoseError(error: error)

            if let cursor = cursor {
                self?.fetchCategories(cursor, managedObjectContext: managedObjectContext)
            }
            completionHandler?()
        }

        operation.recordFetchedBlock = { record in
            fetchedCategoryRecords.append(record)
        }

        CKContainer.shared.publicCloudDatabase.add(operation)
    }
}
