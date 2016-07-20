//
//  MapController.swift
//  Maps
//
//  Created by Rudson Lima on 7/16/16.
//  Copyright © 2016 Rudson Lima. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager();
    }
    
    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Seu não tiver permissão, fazer o pedido de acesso a localização ao usuário
        if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func configureMapView(coordinate: CLLocationCoordinate2D, region: MKCoordinateRegion){
        // Setando informação ao marcador do mapa
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "Fortaleza/CE"
        annotation.subtitle = "Brasil"
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
    }
    
    // MKMapViewDelegate - Custom map pin
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        let annotationReuseId = "Place"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(annotationReuseId)
        
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseId)
        } else {
            anView!.annotation = annotation
        }
        
        anView!.image = UIImage(named: "MapPin")
        anView!.backgroundColor = UIColor.clearColor()
        anView!.canShowCallout = true
        return anView
    }
    
    // CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations.last
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
                
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        configureMapView(location!.coordinate, region: region)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Errors: " + error.localizedDescription)
    }
}

