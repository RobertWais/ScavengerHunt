//
//  Constants.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/23/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//


import Foundation
import UIKit
struct Constants {
    struct Colors {
        static let baseColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
    }
    
    //The mode the player is in
    struct Mode {
        //Mode - 0 = Computer
        //Mode - 1 = LivePlayer
        static var mode = 0
    }
    
    //The Map Zones that are read in
    struct Map{
        static var zones = [String: PowerZone]()
    }
    
    //Everything to do with weapons
    struct Arsenal{
        static var items = [Item]()
        static var itemSet = Set<String>()
        static var totalItems: [String: Item] = [   "1":Item(name: "Axe", damage: 10.0, criticalDamage: 250.0),
                                                 "2":Item(name: "Hammer", damage: 50.0, criticalDamage: 100.0),
                                                 "3":Item(name: "Sword", damage: 80, criticalDamage: 40.0)]
    }
//    Item(name: "Axe", damage: 10000.0),Item(name: "Hammer", damage: 10.0),Item(name: "Sword", damage: 30.0)
}
