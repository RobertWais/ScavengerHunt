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

class MapVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bagBtn: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    let coords = [(43.814466,-91.239214),(43.817338,-91.239096), (43.817245,-91.245297), (43.815023,-91.245254)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        buildSpots()
        
         let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: coords[0].0, longitude: coords[0].1), 500, 500)
        mapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func buildSpots(){
        for index in  0..<coords.count{
            print("Building spots")
            let zone = PowerZone(coordinate: CLLocationCoordinate2D(latitude: coords[index].0, longitude: coords[index].1), radius: 100, id: String(describing: index), item: Item(name: "Axe", damage: Double(index*2)))
            
            
            //Add Pin
            mapView.addAnnotation(zone)
            //Add Overlay
            mapView.add(MKCircle(center: CLLocationCoordinate2D(latitude: coords[index].0, longitude: coords[index].1), radius: 50))
            
            //Start Monitorying
            let fenceRegion = region(with: zone)
            locationManager.startMonitoring(for: fenceRegion)
        }
        
    }
    
    func region(with zone: PowerZone) -> CLCircularRegion {
        let region = CLCircularRegion(center: zone.coordinate, radius: zone.radius, identifier: zone.id)
        region.notifyOnEntry = true
        return region
    }
    
    
    //MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("__-------------------------------------")
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

