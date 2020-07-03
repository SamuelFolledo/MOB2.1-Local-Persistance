//
//  CKContainer+Extensions.swift
//  Day13-CloudKit
//
//  Created by Samuel Folledo on 7/1/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import CloudKit

extension CKContainer {
    static var shared: CKContainer {
        return CKContainer(identifier: "iCloud.com.SamuelFolledo.Day13-CloudKit")
    }
}
