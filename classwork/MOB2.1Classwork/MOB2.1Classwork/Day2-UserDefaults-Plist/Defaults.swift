//
//  Defaults.swift
//  MOB2.1Classwork
//
//  Created by Macbook Pro 15 on 6/3/20.
//  Copyright © 2020 SamuelFolledo. All rights reserved.
//

import Foundation

struct Defaults {
    
    static let token = "token"
    static let tokenKey = "tokenKey"
    
    struct Model {
        var token: String?
        
        init(token: String) {
            self.token = token
        }
    }
    
    static var saveToken = { (token: String) in
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    static var getToken = { () -> Model in
        let token = UserDefaults.standard.string(forKey: tokenKey) ?? ""
        return Model(token: token)
    }
    
    static func clearUserData(){
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
