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
//        fetchCloudKit(recordType: .Post)
        performFetch(recordType: .Post)
    }
    
    func fetchCloudKit(recordType: CKRecord.RecordType) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operationFetch = CKQueryOperation(query: query)
        operationFetch.recordFetchedBlock = { record in
            print("Record = ", record)
        }
        operationFetch.queryCompletionBlock = { [unowned self] (cursor, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("ERRORRRR!!!", error.localizedDescription)
                    return
                }
                print("Done!!")
            }
        }
        CKContainer.shared.publicCloudDatabase.add(operationFetch)
    }
    
    ///Another way of fetching from CloudKit
    func performFetch(recordType: CKRecord.RecordType) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        CKContainer.shared.publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("ERROR \(error.localizedDescription)")
                return
            }
            print("RECORDS \(records!)")
        }
    }
}

