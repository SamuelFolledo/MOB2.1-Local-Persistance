//
//  CKContainer+Extensions.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CloudKit

extension CKContainer {
    static var shared: CKContainer {
        #warning("step 0:- change this to your container name as per the dashboard")
        return CKContainer(identifier: "iCloud.com.")
    }
}
