//
//  User.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 11/1/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot


class User {
    private var _id = ""
    private var _username = ""
    
    init(id: String, username: String){
        self._id = id
        self._username = username
    }
    
    var username: String {
        return _username
    }
    
    var id: String{
        return _id
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String: Any],
            let id = dict["id"] as? String,
            let username = dict["username"] as? String else{
                return nil
            }
        self._id = id
        self._username = username
    }
}
