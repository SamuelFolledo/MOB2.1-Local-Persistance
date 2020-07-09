//
//  CKRecord+Extensions.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit

enum CKRecordKey: String {
    //Category
    case title, order
    //Post
    case thumbnail, sourceName, sourceUrl, url, date, categories
}

extension CKRecord {
    
    subscript(key: CKRecordKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
}

extension CKRecord.RecordType {
    
    public static var Category: String = "Category"
    public static var Post: String = "Post"
}

extension CKRecordZone {
    
    static var favoriteZone: CKRecordZone {
        CKRecordZone(zoneName: "Favorites")
    }
}
