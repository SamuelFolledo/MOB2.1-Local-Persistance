//
//  Cloud+Save.swift
//  News
//
//  Created by Mustafa Yusuf on 15/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CoreData
import CloudKit

extension Cloud {
    
    func saveCategories(records: [CKRecord], managedObjectContext: NSManagedObjectContext) {
        let ids = records.map { $0.recordID.recordName }
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%@ CONTAINS id", ids)
        let categories = try? managedObjectContext.fetch(fetchRequest)
        
        var fetchedCategories: [Category] = []
        
        records.forEach { record in
            let existingCategory = categories?.first(where: { category -> Bool in
                record.recordID.recordName == category.id?.uuidString
            })
            let category = existingCategory ?? Category(context: managedObjectContext)
            category.id = UUID(uuidString: record.recordID.recordName)
            category.title = record[.title] as? String
            category.order = record[.order] as? Int16 ?? 0
            fetchedCategories.append(category)
        }
        
        fetchPosts(cursor: nil, for: fetchedCategories, managedObjectContext: managedObjectContext)
    }
    
    func savePosts(records: [CKRecord], managedObjectContext: NSManagedObjectContext, areFavorites: Bool? = nil) {
        let categoryIds = records
            .compactMap { $0[.categories] as? [CKRecord.Reference] }
            .reduce([], +)
            .map { $0.recordID.recordName }
            .compactMap { UUID(uuidString: $0) }
        
        
        let postIds = records
            .map { $0.recordID.recordName }
            .compactMap { UUID(uuidString: $0) }
        
        let postsFetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        postsFetchRequest.predicate = NSPredicate(format: "%@ CONTAINS id", postIds)
        let posts = try? managedObjectContext.fetch(postsFetchRequest)
        
        let categoriesFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        categoriesFetchRequest.predicate = NSPredicate(format: "%@ CONTAINS id", categoryIds)
        let categories = try? managedObjectContext.fetch(categoriesFetchRequest)
        
        
        records.forEach { record in
            let existingPost = posts?.first(where: { category -> Bool in
                record.recordID.recordName == category.id?.uuidString
            })
            let post = existingPost ?? Post(context: managedObjectContext)
            post.id = UUID(uuidString: record.recordID.recordName)
            post.title = record[.title] as? String
            post.url = URL(string: record[.url] as? String ?? "")
            post.sourceName = record[.order] as? String
            post.date = record[.date] as? Date
            post.sourceURL = URL(string: record[.sourceUrl] as? String ?? "")
            
            let asset = record[.thumbnail] as? CKAsset

            
            if let asset = asset, let url = asset.fileURL {
                post.thumbnailImageData = try? Data(contentsOf: url)
            }
            
            let postCategoryIds = (record[.categories] as? [CKRecord.Reference])?
                .map { $0.recordID.recordName }
            let filteredCategories = categories?
                .filter {
                    postCategoryIds?.contains($0.id?.uuidString ?? "") ?? false
            }
            if let filteredCategories = filteredCategories {
                post.categories = NSSet(array: filteredCategories)
            }
            if let isFavorite = areFavorites {
                post.isFavorite = isFavorite
            }
        }
        
        try? managedObjectContext.save()
    }

}
