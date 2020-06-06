//
//  UserDefaultsWrapper.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/5/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import Foundation

private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}

@propertyWrapper
struct UserDefaultsWrapper<Type> {
    let key: String
    let defaultValue: Type
    let userDefaults: UserDefaults = .standard
    
    var wrappedValue: Type {
        get {
            return userDefaults.object(forKey: key) as? Type ?? defaultValue
        }
        set {
            if let optional = newValue as? AnyOptional, optional.isNil { //check if there is no value, remove it
                UserDefaults.standard.removeObject(forKey: key)
            } else { //if there is a newValue and it is not nil
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}
