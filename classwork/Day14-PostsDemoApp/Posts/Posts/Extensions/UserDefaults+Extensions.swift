//
//  UserDefaults+Extensions.swift
//  News
//
//  Created by Mustafa Yusuf on 07/05/20.
//  Copyright © 2020 Mustafa. All rights reserved.
//

import Foundation
import CloudKit.CKServerChangeToken

extension UserDefaults {
    
    var isSubscribed: Bool {
        get {
            value(forKey: "isSubscribed") as? Bool ?? false
        }
        set {
            setValue(newValue, forKey: "isSubscribed")
            synchronize()
        }
    }
    
    var isSubscribedToSilentChanges: Bool {
        get {
            value(forKey: "isSubscribedToSilentChanges") as? Bool ?? false
        }
        set {
            setValue(newValue, forKey: "isSubscribedToSilentChanges")
            synchronize()
        }
    }
    
    var isFavoriteZoneCreated: Bool {
        get {
            value(forKey: "isFavoriteZoneCreated") as? Bool ?? false
        }
        set {
            setValue(newValue, forKey: "isFavoriteZoneCreated")
            synchronize()
        }
    }
    
    var favoriteZoneServerChangeToken: CKServerChangeToken? {
        get {
            guard let data = self.value(forKey: "favoriteZoneServerChangeToken") as? Data else {
                return nil
            }
            
            let token: CKServerChangeToken?
            do {
                token = try NSKeyedUnarchiver.unarchivedObject(ofClass: CKServerChangeToken.self, from: data)
            } catch {
                token = nil
            }
            
            return token
        }
        set {
            if let token = newValue {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: false)
                    self.set(data, forKey: "favoriteZoneServerChangeToken")
                } catch {
                    // handle error
                }
            } else {
                self.removeObject(forKey: "favoriteZoneServerChangeToken")
            }
        }
    }
}
