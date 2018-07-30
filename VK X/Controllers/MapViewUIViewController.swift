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

class MapViewUIViewController: UIViewController, CLLocationManagerDelegate {
  
  let annotation = MKPointAnnotation()
  let locationManager = CLLocationManager()
  var place: CLPlacemark?
  var sender: Any?
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    place = nil
    
    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    self.locationManager.requestWhenInUseAuthorization()
    self.locationManager.startUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let currentLocation = locations.last?.coordinate {
      let coordinate = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
      let coder = CLGeocoder()
      coder.reverseGeocodeLocation(coordinate) { (myPlaces, Error) -> Void in
        self.place = myPlaces?.first
      }
      let currentRadius: CLLocationDistance = 1000
      let currentRegion = MKCoordinateRegion(center: currentLocation, span: MKCoordinateSpan(latitudeDelta: currentRadius * 2.0, longitudeDelta: currentRadius * 2.0))
      self.mapView.setRegion(currentRegion, animated: true)
      self.mapView.showsUserLocation = true
      
      annotation.coordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude)
      mapView.addAnnotation(annotation)
    }
  }
  
  @IBAction func closeMap(_ sender: Any) {
    if let sender = self.sender as? NewPostUIViewController {
      sender.place = self.place
    }
    dismiss(animated: true, completion: nil)
  }
}
