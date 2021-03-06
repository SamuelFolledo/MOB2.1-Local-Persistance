//
//  Meal.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class Meal {
    
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals") //old not working
//    static let ArchiveURL: URL = URL(fileURLWithPath: "meals", relativeTo: FileManager.documentsDirectoryURL)
    
    //MARK: Example
//    let anArray : [UInt8] = [226, 143, 179, 226, 156, 136, 239, 184, 143, 240, 159, 165, 179]
//    let exampleURL = URL(fileURLWithPath: "message", relativeTo: FileManager.documentsDirectoryURL).appendingPathExtension("txt") //message.txt file
//    let dataFromArray = Data(anArray)
//    print(exampleURL)
//    try dataFromArray.write(to: exampleURL, options: .atomic)
//    //read
//    let savedData = try Data.init(contentsOf: exampleURL)
//    print(savedData)
//    let arrayFromData = Array(savedData)
//    print(arrayFromData)
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
    //MARK: Decode from data
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        rating = try container.decode(Int.self, forKey: .rating)
        
        let photoData = try container.decode(Data.self, forKey: .photo) //turn photo to data
        photo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(photoData) as? UIImage ?? UIImage()
    }
}

extension Meal: Codable {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case photo = "photo"
        case rating = "rating"
    }
    
    //MARK: Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(rating, forKey: .rating)
        let photoData = try NSKeyedArchiver.archivedData(withRootObject: photo!, requiringSecureCoding: false)
        try container.encode(photoData, forKey: .photo)
    }
}
