//
//  UserStore.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation

enum UserMode: String {
    case signle = "Single"
    case realTime = "Real Time"
    init(status:Bool){
        if status {
            self = .realTime
        }else{
            self = .signle
        }
    }
}

class UserStore{
    private static let userModeKey: String = "userModeKey"
    static func save(userMode: Bool) {
        UserDefaults.standard.setValue(userMode, forKey: userModeKey)
    }
    
    static func removeUserMode() {
        UserDefaults.standard.removeObject(forKey: userModeKey)
    }
    
    static func getUserMode() -> Bool? {
        return UserDefaults.standard.object(forKey: userModeKey) as? Bool
    }
}
