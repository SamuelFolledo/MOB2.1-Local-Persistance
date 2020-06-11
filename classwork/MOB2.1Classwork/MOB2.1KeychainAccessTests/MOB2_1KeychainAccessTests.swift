//
//  MOB2_1KeychainAccessTests.swift
//  MOB2.1KeychainAccessTests
//
//  Created by Samuel Folledo on 6/10/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

//MARK: How to create a test file https://basememara.com/unit-testing-in-swift-xcode-and-beyond/#:~:text=Click%20the%20%E2%80%9CAdd%20a%20target,(where%20your%20code%20is).

import XCTest
import KeychainAccess
@testable import MOB2_1Classwork

class MOB2_1KeychainAccessTests: XCTestCase {
    
    var day5VC: Day5VC = Day5VC()
    let keychain = Keychain(service: "Mobile2.1App")

    func testSave() {
        day5VC.save(key: "name", text: "Samuel")
        XCTAssertEqual(day5VC.reveal(key: "name"), "Samuel")
        
        day5VC.save(key: "password", text: "unknown password")
        XCTAssertNotEqual(day5VC.reveal(key: "password"), "Unknown password")
    }
    
    func testReveal() {
        XCTAssertEqual(day5VC.reveal(key: "firstName"), nil)
        
        XCTAssertNotEqual(day5VC.reveal(key: "password"), "Unknown password")
        
        day5VC.save(text: "new message")
        XCTAssertEqual(day5VC.reveal(), "new message")
        day5VC.delete(key: "old message") //deleting differnt key
        XCTAssertEqual(day5VC.reveal(), "new message")
        day5VC.delete()
        XCTAssertEqual(day5VC.reveal(), nil)
    }
}
