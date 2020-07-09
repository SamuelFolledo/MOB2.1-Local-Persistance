//
//  CloudSync.swift
//  News
//
//  Created by Mustafa Yusuf on 07/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit
import CoreData

extension Cloud {
    
    func createFavoriteCustomZone(managedObjectContext: NSManagedObjectContext) {
        
        #warning("step 3:- creating a custom zone for favorites")
        
        let operation = CKModifyRecordZonesOperation(recordZonesToSave: [.favoriteZone], recordZoneIDsToDelete: nil)
        operation.modifyRecordZonesCompletionBlock = { [weak self] zonesCreated, _, error in
            if error == nil {
                UserDefaults.standard.isFavoriteZoneCreated = true
                self?.syncFavorites(managedObjectContext: managedObjectContext)
            }
        }
        CKContainer.shared.privateCloudDatabase.add(operation)
    }
    
    func syncFavorites(managedObjectContext: NSManagedObjectContext) {
        
        #warning("step 4:- syncing the favorites from our app to the Cloud")
        guard UserDefaults.standard.isFavoriteZoneCreated else {
            createFavoriteCustomZone(managedObjectContext: managedObjectContext)
            return
        }
        let request: NSFetchRequest<Post> = Post.fetchRequest()
        request.predicate = NSPredicate(format: "isSynced == false")
        let unsyncedPosts = try? managedObjectContext.fetch(request)
        let postsToSave = unsyncedPosts?.filter { $0.isFavorite }
        let recordsToSave = postsToSave?.map { $0.asCKRecord }
        let postsToDelete = unsyncedPosts?.filter { !$0.isFavorite }
        let recordsToDelete = postsToDelete?.map { $0.asCKRecord.recordID }

        let operation = CKModifyRecordsOperation(
            recordsToSave: recordsToSave,
            recordIDsToDelete: recordsToDelete
        )

        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecords, error in
            managedObjectContext.perform {
                savedRecords?.forEach { record in
                    let savedPost = postsToSave?.first(where: { post -> Bool in
                         post.id?.uuidString == record.recordID.recordName
                    })
                    savedPost?.isSynced = true
                }
                deletedRecords?.forEach { recordID in
                    let deletedPost = postsToDelete?.first(where: { post -> Bool in
                         post.id?.uuidString == recordID.recordName
                    })
                    deletedPost?.isSynced = true
                }
            }
        }

        CKContainer.shared.privateCloudDatabase.add(operation)
    }
    
    func fetchUpdates(managedObjectContext: NSManagedObjectContext) {
        
        #warning("step 5:- fetching all updates from our `Favorites` zone")
        let configuration = CKFetchRecordZoneChangesOperation.ZoneConfiguration(
            previousServerChangeToken: UserDefaults.standard.favoriteZoneServerChangeToken,
            resultsLimit: 200,
            desiredKeys: nil
        )

        var recordsFavorited: [CKRecord.ID] = []
        var recordsUnfavorited: [CKRecord.ID] = []

        let operation = CKFetchRecordZoneChangesOperation(
            recordZoneIDs: [CKRecordZone.favoriteZone.zoneID],
            configurationsByRecordZoneID: [CKRecordZone.favoriteZone.zoneID: configuration]
        )
        operation.fetchAllChanges = true

        operation.recordZoneFetchCompletionBlock = { zoneRecordID, serverChangeToken, data, moreComing, error in
            if let token = serverChangeToken {
                UserDefaults.standard.favoriteZoneServerChangeToken = token
            }
        }

        operation.recordChangedBlock = { record in
            recordsFavorited.append(record.recordID)
        }

        operation.recordWithIDWasDeletedBlock = { recordID, _ in
            recordsUnfavorited.append(recordID)
        }

        operation.completionBlock = {
            managedObjectContext.perform { [weak self] in
                self?.syncFavorties(recordsFavorited, recordsUnfavorited, managedObjectContext: managedObjectContext)
            }
        }

        CKContainer.shared.privateCloudDatabase.add(operation)
    }
    
    func syncFavorties(_ favoritedRecordIDs: [CKRecord.ID], _ unfavoritedRecordIDs: [CKRecord.ID], managedObjectContext: NSManagedObjectContext) {
        var postIds = favoritedRecordIDs.map { $0.recordName }
        postIds.append(contentsOf: unfavoritedRecordIDs.map { $0.recordName})
        
        let postUUIDs = postIds.compactMap { UUID(uuidString: $0) }
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ contains id", postUUIDs)
        let posts = try? managedObjectContext.fetch(fetchRequest)
        
        posts?.forEach { post in
            post.isFavorite = favoritedRecordIDs.contains(where: { $0.recordName == post.id?.uuidString })
        }
        
        try? managedObjectContext.save()
        
        let postsNotFoundLocally = favoritedRecordIDs.filter { record in
            return !(posts?.contains(where: { $0.id?.uuidString == record.recordName }) ?? false)
        }
        
        fetchPosts(with: postsNotFoundLocally, managedObjectContext: managedObjectContext, areFavorites: true)
    }
    
    func fetchPosts(with recordIDs: [CKRecord.ID], managedObjectContext: NSManagedObjectContext, areFavorites: Bool? = nil) {
        
        #warning("step 6:- how to fetch record with their IDs")
        
        var fetchedPostRecords: [CKRecord] = []

        let fetchRecordIds = recordIDs.map { CKRecord.ID(recordName: $0.recordName) }

        let operation = CKFetchRecordsOperation(recordIDs: fetchRecordIds)

        operation.perRecordCompletionBlock = { [weak self] record, recordID, error in
            if let record = record {
                fetchedPostRecords.append(record)
            }

            self?.diagnoseError(error: error)
        }

        operation.completionBlock = { [weak self] in
            managedObjectContext.perform { [weak self] in
                self?.savePosts(records: fetchedPostRecords, managedObjectContext: managedObjectContext, areFavorites: areFavorites)
            }
        }

        CKContainer.shared.publicCloudDatabase.add(operation)
    }
}

extension Cloud {
    
    func subscribeToNotifcations() {
        
        #warning("step 7:- notifications for creation creation/update")
        
        guard !UserDefaults.standard.isSubscribed else { return }

        let subscription = CKQuerySubscription(recordType: .Post, predicate: .init(value: true), options: .firesOnRecordCreation)
        let notification = CKSubscription.NotificationInfo()
        notification.alertLocalizationKey = "%@"
        notification.alertLocalizationArgs = [CKRecordKey.title.rawValue]
        notification.titleLocalizationKey = "%@"
        notification.titleLocalizationArgs = [CKRecordKey.sourceName.rawValue]
        notification.shouldBadge = false
        subscription.notificationInfo = notification

        let silentSubscription = CKQuerySubscription(recordType: .Post, predicate: .init(value: true), options: [.firesOnRecordCreation, .firesOnRecordUpdate])
        let silentNotification = CKSubscription.NotificationInfo()
        silentNotification.shouldSendContentAvailable = true
        silentSubscription.notificationInfo = silentNotification

        let publicOperation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription, silentSubscription], subscriptionIDsToDelete: nil)
        publicOperation.modifySubscriptionsCompletionBlock = { subscriptionsCreated, _ , error in
            if error == nil {
                UserDefaults.standard.isSubscribed = true
            }
        }

        CKContainer.shared.publicCloudDatabase.add(publicOperation)
    }
    
    func subscribeToPrivateDatabaseNotifications() {
        
        #warning("step 8:- notifications for when user favorites something on one device")
        
        guard !UserDefaults.standard.isSubscribedToSilentChanges else { return }

        let silentSubscription = CKDatabaseSubscription(subscriptionID: "the-quiet-one-private")
        let silentNotification = CKSubscription.NotificationInfo()
        silentNotification.shouldSendContentAvailable = true
        silentSubscription.notificationInfo = silentNotification

        let privateOperation = CKModifySubscriptionsOperation(subscriptionsToSave: [silentSubscription], subscriptionIDsToDelete: nil)
        privateOperation.modifySubscriptionsCompletionBlock = { subscriptionsCreated, _ , error in
            if error == nil {
                UserDefaults.standard.isSubscribedToSilentChanges = true
            }
        }

        CKContainer.shared.privateCloudDatabase.add(privateOperation)
    }
}
