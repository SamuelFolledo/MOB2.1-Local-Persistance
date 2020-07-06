//
//  CKRecord+Extensions.swift
//  Day13-CloudKit
//
//  Created by Samuel Folledo on 7/1/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import CloudKit

extension CKRecord {
//    enum CKRecordKey: String {
//        //Category
//        case title, order
//        //Post
//        case thumbnail, url, date, category
//    }
    
//    subscript(key: Post.PostKey) -> Any? {
//        get {
//            return self[key.rawValue]
//        }
//        set {
//            self[key.rawValue] = newValue as? CKRecordValue
//        }
//    }
}

extension CKRecord.RecordType {
    public static var Category: String = "Category"
    public static var Post: String = "Post"
}

extension CKRecord.FieldKey {
    public static var title: String = "title"
    public static var order: String = "order"
    public static var category: String = "category"
    public static var date: String = "date"
    public static var url: String = "url"
    public static var thumbnail: String = "thumbnail"
}
