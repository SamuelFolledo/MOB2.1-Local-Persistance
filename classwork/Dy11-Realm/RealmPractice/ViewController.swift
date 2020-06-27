//
//  ViewController.swift
//  RealmPractice
//
//  Created by Adriana González Martínez on 5/2/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let store = BookStore()
        let realm = try! Realm()
        store.realm = realm
        
        let book = Book(value: ["title": "A Game of Thrones (A Song of Ice and Fire #1)", "George R. R. Martin": "", "year": 1997])
        let book2 = Book(value: ["title": "Cat in the Hat", "Dr. Seuss": "", "year": 1957])
        let bookStore = BookStore()
        bookStore.realm = realm
        try? bookStore.deleteBook(book)
        try? bookStore.deleteBook(book2)
        print("Final", realm.objects(Book.self))
    }
}
