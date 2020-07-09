//
//  Post+Extension.swift
//  News
//
//  Created by Mustafa on 06/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import CoreData
import CloudKit
import UIKit.UIImage

extension Post {
        
    var asCKRecord: CKRecord {
        let record: CKRecord
        let zoneID = CKRecordZone.favoriteZone.zoneID
        
        if let id = id {
            record = CKRecord(recordType: CKRecord.RecordType.Post, recordID: .init(recordName: id.uuidString, zoneID: zoneID))
        } else {
            let newId = UUID()
            self.id = newId
            record = CKRecord(recordType: CKRecord.RecordType.Post, recordID: .init(recordName: newId.uuidString, zoneID: zoneID))
        }
        return record
    }
}

extension Post {
    
    var thumbnail: UIImage? {
        guard let thumbnailData = thumbnailImageData else {
            return nil
        }
        return UIImage(data: thumbnailData)
    }
}
