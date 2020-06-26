//
//  BookStore.swift
//  RealmPractice
//
//  Created by Adriana González Martínez on 5/5/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import Foundation
import RealmSwift

enum RuntimeError: Error {
    case NoRealmSet
}

class BookStore {
    var realm: Realm?

    public func saveBook(_ book: Book){
        //TODO: save the book
    }
    
    public func findBooksByTitle(_ title: String) -> Results<Book>{
        //TODO: create the predicate that matches titles
        let predicate = NSPredicate()
        return realm!.objects(Book.self).filter(predicate)
    }
    
    public func createBook(_ title: String, author: String, year: Int ) -> Book{
        let newBook = Book()
        //TODO: set the properties
        return newBook
    }
    
    public func updateBooks(_ field: String, currentValue: String, updatedValue: String) throws
    {
        let books = try findBooksByField(field, value: currentValue)
        try! realm!.write {
            books.setValue(updatedValue, forKey: "\(field)")
        }
    }
    
    private func findBooksByField(_ field: String, value: String) throws -> Results<Book>
    {
        if (realm != nil) {
            let predicate = NSPredicate(format: "%K = %@", field, value)
            return realm!.objects(Book.self).filter(predicate)
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    public func deleteBook(_ book: Book) throws {
        //TODO: delete the book
      
    }
}
