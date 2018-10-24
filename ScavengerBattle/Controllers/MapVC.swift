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

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var bagBtn: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

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
