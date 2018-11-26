//
//  MapVC.swift
//  ScavengerBattle
//
//  Created by Robert Wais on 10/24/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseDatabase.FIRDataSnapshot

protocol AlertDelegate: class {
    func sendAlert(id: String)
}

class MapVC: UIViewController, MKMapViewDelegate,AlertDelegate {

    @IBOutlet weak var timerLblView: UIView!
    @IBOutlet weak var timerLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bagBtn: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    let coords = [(43.814466,-91.239214),(43.817338,-91.239096), (43.817245,-91.245297), (43.815023,-91.245254)]
    var count = 0
    var ref: DatabaseReference!
    var zones: DatabaseReference!
    var elapsedTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLblView.layer.cornerRadius = timerLblView.layer.frame.height/2
        
        ref = Database.database().reference()
        zones = ref.child("Zones")
        
        let appDel = UIApplication.shared.delegate as! AppDelegate
        appDel.delegateAlert = self
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        buildSpots()
        
         let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: coords[0].0, longitude: coords[0].1), 500, 500)
        mapView.setRegion(region, animated: true)
        
        setGameTime()
    }
    
    func sendAlert(id: String){
            print("Sending Alert Happened")
            print("Adding Weapon: \(count) to your arsenal ")
            let alert = UIAlertController(title: "Title", message: "Message", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(cancelButton)
            self.present(alert, animated: false, completion: nil)
            count += 1
        
        //Get zone from ID
        //Look up weapon from zoneID
        guard let powerZone = Constants.Map.zones[id] else {return}
        let itemId = powerZone.itemID
        
        //Get the item for the the weapon list
        guard let addItem = Constants.Arsenal.totalItems[itemId] else {return}
        Constants.Arsenal.items.append(addItem)
        
        
        print("Items so far........  ")
        for item in Constants.Arsenal.items {
            print("Item: \(item.name), does \(item.damage) damage")
        }
    }
    
    @IBAction func bagBtnPressed(_ sender: Any) {
        let modalVC = storyboard?.instantiateViewController(withIdentifier: "BagModalVC") as! BagModalVC
        modalVC.modalPresentationStyle = .overCurrentContext
        present(modalVC, animated: true,completion: nil)
        
    }
    @IBAction func zoomToUserLocation(_ sender: Any) {
        print("Tapped")
        mapView.zoomOnUser()
    }
    
    func addZones(){
        ref = Database.database().reference()
        for index in 0..<coords.count {
            
            guard let key = ref.child("Zones").childByAutoId().key else{
                return
            }
            let zone: [String: Any] = ["coordinates": ["X":coords[index].0,"Y":coords[index].1],
                                       "radius": 10,
                                       "id": String(describing: index),
                                       "itemID": "FirstItemID"]
            ref.child("Zones").child(key).setValue(zone)
        }
    }
    
    //Load Spots In
    func buildSpots(){
        zones.observe(DataEventType.value){ snapshot in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                print("Key: \(child.key)")
                
                guard let zone = PowerZone(snapshot: child) else{
                    print("Error loading")
                    return
                }
                print("Weapon in zone: \(zone.id) has item: \(String(describing: Constants.Arsenal.totalItems[zone.itemID]?.name))")
                //Add Pin
                self.mapView.addAnnotation(zone)
                //Add Overlay
                self.mapView.add(MKCircle(center: CLLocationCoordinate2D(latitude: zone.coordinate.latitude, longitude: zone.coordinate.longitude), radius: zone.radius))
                
                //Start Monitorying
                let fenceRegion = self.region(with: zone)
                self.locationManager.startMonitoring(for: fenceRegion)
                
                //Add to List of Zones
                Constants.Map.zones[zone.id] = zone
            }
        }
    }
    
    func region(with zone: PowerZone) -> CLCircularRegion {
        let region = CLCircularRegion(center: zone.coordinate, radius: zone.radius, identifier: zone.id)
        region.notifyOnEntry = true
        return region
    }
    
    
    //MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let id = "powerZone"
        if annotation is PowerZone {
            var zoneView = mapView.dequeueReusableAnnotationView(withIdentifier: id) as? MKPinAnnotationView
            if zoneView == nil{
                zoneView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
                //Able to add stuff to annotation bubble
                zoneView?.canShowCallout = true
                
            }else{
                //REVISIT
                zoneView?.annotation = annotation
            }
            return zoneView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.lineWidth = 2.0
            renderer.strokeColor = .blue
            renderer.fillColor = UIColor.blue.withAlphaComponent(0.3)
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    }
    
    func setGameTime(){
        let time = Timer(timeInterval: 1, repeats: true) { (timer) in
            print("Fired()")
            self.elapsedTime += 1
            self.timerLbl.text = "Time Left: \(5-self.elapsedTime)"
            if self.elapsedTime >= 5 {
                self.timerLbl.text = "Time Over"
                
                let storyboard: UIStoryboard = UIStoryboard(name: "Battle", bundle: .main)
                let viewController = storyboard.instantiateInitialViewController()!
                self.show(viewController, sender: self)
                timer.invalidate()
            }
            
        }
        RunLoop.current.add(time, forMode: .defaultRunLoopMode)
    }
}

extension MKMapView {
    func zoomOnUser() {
        guard let coordinate = userLocation.location?.coordinate else { return }
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000)
        setRegion(region, animated: true)
    }
}

extension MapVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        mapView.showsUserLocation = status == .authorizedAlways
    }
}

extension MapVC {
    
}

