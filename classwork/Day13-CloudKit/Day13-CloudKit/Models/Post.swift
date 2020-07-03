//
//  Post.swift
//  Day13-CloudKit
//
//  Created by Samuel Folledo on 7/1/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import Foundation

struct Post {
    var title: String
    var url: URL
    var date: Date
    var categories: String
    
    init(title: String, url: URL, categories: String) {
        self.title = title
        self.url = url
        self.date = Date()
        self.categories = categories
    }
    
    enum PostKey: String {
        case title
        case url
        case date
        case categories
    }
}

struct Category {
    enum CategoryKey: String {
        case title
        case order
    }
}
