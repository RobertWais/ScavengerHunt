//
//  PowerZone.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import FirebaseDatabase.FIRDataSnapshot

class PowerZone: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var id: String
    var itemID: String
    
    var title: String? {
        return "PowerUp"
    }
    
    var subtitle: String? {
        return "Damage"
    }
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, id: String){
        self.coordinate = coordinate
        self.radius = radius
        self.id = id
        self.itemID = "itemID"
    }
    
    init?(snapshot: DataSnapshot){
        guard let dict = snapshot.value as? [String:Any],
        let id = dict["id"] as? String,
        let itemid = dict["itemID"] as? String,
        let radius = dict["radius"] as? Double,
        let coords = dict["coordinates"] as? [String:Any],
        let x = coords["X"] as? Double,
            let y = coords["Y"] as? Double else{
                return nil
        }
        self.id = id
        self.itemID = itemid
        self.radius = radius
        self.coordinate = CLLocationCoordinate2D(latitude: x, longitude: y)
    }
}
