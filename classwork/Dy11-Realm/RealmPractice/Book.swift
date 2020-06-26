//
//  Book.swift
//  RealmPractice
//
//  Created by Adriana González Martínez on 5/2/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import Foundation
import RealmSwift

class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var author = ""
    @objc dynamic var year = 0
}
