//
//  MapViewUIViewController.swift
//  VK X
//
//  Created by Artem Kufaev on 26/07/2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class MapViewUIViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var place: CLPlacemark?
    var sender: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last?.coordinate {
            let coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            
            let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
            
            mapView.camera = camera
            
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
        }
    }
    
    @IBAction func closeMap(_ sender: Any) {
        if let sender = self.sender as? NewPostUIViewController {
            sender.place = self.place
        }
        dismiss(animated: true, completion: nil)
    }

}
