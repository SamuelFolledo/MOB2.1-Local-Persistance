//
//  Category+Extensions.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit
import CoreData

extension Category {
    
    var recordID: CKRecord.ID {
        .init(recordName: id?.uuidString ?? "")
    }
}

extension Category {
    
    func getRecentPosts(_ maxCount: Int) -> [Post] {
        guard var posts = posts?.allObjects as? [Post] else {
            return []
        }
        posts.sort(by: { ($0.date ?? Date()) > ($1.date ?? Date()) })
        return Array(posts.prefix(maxCount))
    }
}
