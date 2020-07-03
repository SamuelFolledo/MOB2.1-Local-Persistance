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
    
    let record = CKRecord(recordType: "Post")

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        record[.title] = "Mondale is Pinoy"
        record[.url] = ""
        record[.categories] = "Pinoy"
        record[.date] = Date()
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
}

