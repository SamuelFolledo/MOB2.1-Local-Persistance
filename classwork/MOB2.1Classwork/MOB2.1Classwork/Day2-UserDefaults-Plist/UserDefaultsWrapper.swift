//
//  UserDefaultsWrapper.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/5/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Value> {
    let key: String
    let defaultValue: Value
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return userDefaults.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
