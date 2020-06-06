//
//  Defaults.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/3/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import Foundation

struct Defaults {
    
    @UserDefaultsWrapper(key: "tokenKey", defaultValue: "") static var token: String
    
    @UserDefaultsWrapper(key: "preferredLanguage", defaultValue: "") static var preferredLanguage: String? //make it optional if you want to be able to set it
    
    @UserDefaultsWrapper(key: "person", defaultValue: nil) static var person: NSCodingPerson?
}
