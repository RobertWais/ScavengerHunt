//
//  Item.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation


class Item{
    private var _name = ""
    private var _damage = 0.0
    
    init(name: String, damage: Double){
        self._name = name
        self._damage = damage
    }
    
    var name: String {
        return _name
    }
    
    var damage: Double{
        return _damage
    }
    
}
