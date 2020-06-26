//
//  RealmPracticeTests.swift
//  RealmPracticeTests
//
//  Created by Adriana González Martínez on 5/2/19.
//  Copyright © 2019 Adriana González Martínez. All rights reserved.
//

import XCTest
import RealmSwift

@testable import RealmPractice

class RealmPracticeTests: XCTestCase {

    var bookStore: BookStore!
    
    override func setUp() {
        // Notice you can configure Realms before creating them. Here we use the in-memory type.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()

        bookStore = BookStore()
        bookStore.realm = realm
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSaveAndGetBook() {
        
        //Given a new book with title: Jungle Book, author: Rudyard Kipling and year: 1894
         let book = bookStore.createBook("Jungle Book", author: "Rudyard Kipling", year: 1894)
        
        //When saved to the database
        bookStore.saveBook(book)

        //Then we get find it by name and make sure the year is 1894
         let foundBooks = bookStore.findBooksByTitle("Jungle Book")
         XCTAssertEqual(foundBooks.count, 1)
        
         let firstBook = foundBooks.first
         XCTAssertEqual(firstBook?.year, 1894)
    }
    

    func testSaveAndUpdateBook() {
       
        do {
            //Given a book: Hamlet, William, 1599

            
            
            //When updating the author to William Shakespeare
            
            //...
            
            try bookStore.updateBooks("", currentValue: "", updatedValue: "")
            
            //Then we find it again and make sure the author's name matches the new value
            
            
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }

       
       
    }
    
    func testDelete() {
        
       
    }
    
}
