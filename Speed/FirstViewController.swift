//
//  FirstViewController.swift
//  Speed
//
//  Created by Matheus Amendola on 16/05/20.
//  Copyright © 2020 Matheus Amendola. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class FirstViewController: UIViewController {
    let regionInMeters: Double = 1000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lbVelocity: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //Aparece um alerta que o usuario precisa ativar.
        }
    }
    
    func centerViewOnUserLocation() {
        if let  location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //Show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show a alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    

}

extension FirstViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        var speed = location.speed * 3.6
        if speed <= 0 {
            speed = 0
        }
        print(speed)
        
        if speed >= 0 {
        
            let animation:CATransition = CATransition()
            animation.timingFunction = CAMediaTimingFunction(name:
                CAMediaTimingFunctionName.easeInEaseOut)
            animation.type = CATransitionType.fade
            animation.subtype = CATransitionSubtype.fromTop
            self.lbVelocity.text = String(Int(speed))
            animation.duration = 0.25
            self.lbVelocity.layer.add(animation, forKey: CATransitionType.fade.rawValue)
            
        }
        
        let center = CLLocationCoordinate2D.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
       checkLocationAuthorization()
        
    }
    
}
