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

class PowerZone: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var id: String
    var item: Item
    
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, id: String, item: Item){
        self.coordinate = coordinate
        self.radius = radius
        self.id = id
        self.item = item
    }
}
