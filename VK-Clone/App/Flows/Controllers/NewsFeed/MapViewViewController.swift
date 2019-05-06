//
//  MapViewViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 26/07/2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps

class MapViewViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    var sender: Any?
    var marker: GMSMarker?
    
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
            
            if let marker = marker {
                marker.position = coordinate
            } else {
                marker = GMSMarker(position: coordinate)
                marker!.map = mapView
            }
        }
    }
    
    @IBAction func closeMap(_ sender: Any) {
        if let sender = self.sender as? NewPostViewController {
            sender.location = self.marker?.position
            sender.placeButton?.tintColor = UIColor.init(red: 44/255, green: 166/255, blue: 72/255, alpha: 1)
        }
        dismiss(animated: true, completion: nil)
    }

}
