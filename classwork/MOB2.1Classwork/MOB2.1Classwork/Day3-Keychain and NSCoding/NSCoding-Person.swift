//
//  NSCoding-Person.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/5/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import UIKit

struct NSCodingPerson {
    var name: String
    var favoriteColor: UIColor //cant store in UserDefaults
}

extension NSCodingPerson: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case favoriteColor
    }
    
    //MARK: Decode
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        
        let colorData = try container.decode(Data.self, forKey: .favoriteColor)
        favoriteColor = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor ?? UIColor.purple
    }
    
    //MARK: Encode
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        let colorData = try NSKeyedArchiver.archivedData(withRootObject: favoriteColor, requiringSecureCoding: false)
        try container.encode(colorData, forKey: .favoriteColor)
    }
}
