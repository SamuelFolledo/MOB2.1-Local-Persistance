//
//  ViewController.swift
//  Day13-CloudKit
//
//  Created by Samuel Folledo on 7/1/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
    
    let postRecord = CKRecord.init(recordType: .Post, recordID: CKRecord.ID(recordName: UUID().uuidString))

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

