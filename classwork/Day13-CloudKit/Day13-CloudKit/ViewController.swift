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
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let categoryRecord = CKRecord(recordType: .Category, recordID: .init(recordName: UUID().uuidString))
        categoryRecord[.title] = ""
        categoryRecord[.date] = Date()
        categoryRecord[.category] = ""
        categoryRecord[.url] = ""

        let operation = CKModifyRecordsOperation(recordsToSave: [categoryRecord], recordIDsToDelete: nil)
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIds, error in

          if let error = error {
              fatalError(error.localizedDescription)
          } else if let records = savedRecords {
              print(records)
          } else {
            fatalError()
          }
        }
        CKContainer.shared.publicCloudDatabase.add(operation)
    }
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
}

