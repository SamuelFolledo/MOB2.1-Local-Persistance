//
//  AddPostController.swift
//  Day13-CloudKit
//
//  Created by Samuel Folledo on 7/1/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit
import CloudKit

class AddPostController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var orderTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let order = orderTextField.text, !order.isEmpty else { return }
        let postRecord = CKRecord(recordType: .Post, recordID: .init(recordName: UUID().uuidString))
        postRecord[.title] = title
        postRecord[.date] = Date()
        postRecord[.category] = "no category"
        postRecord[.url] = "n/a"
        saveRecord(records: [postRecord])
    }
    
    func saveRecord(records: [CKRecord]) {
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
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
}
