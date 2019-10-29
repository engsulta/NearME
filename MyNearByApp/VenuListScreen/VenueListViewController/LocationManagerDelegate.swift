//
//  LocationManagerDelegate.swift
//  MyNearByApp
//
//  Created by Ahmed Sultan on 10/29/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
extension VenueListViewController: CLLocationManagerDelegate {
    func setupCoreLocation(){
        switch CLLocationManager.authorizationStatus(){
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedAlways, .authorizedWhenInUse:
            enableLocationServices()
        case .restricted, .denied:
            handleNonAuthorizedLocation()
        @unknown default:
            break
        }
    }
    
    fileprivate func setupNewRegion() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
                if let fetchedRegion = fetchedRegionCenter {
                let region = CLCircularRegion(center: fetchedRegion, radius: 50, identifier: "id")
                region.notifyOnExit = true
                locationManager?.startMonitoring(for: region)
                }
            }
        }
    }
    
    func enableLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
        }
        
    }
    
    func disableLocationServies(){
        locationManager?.stopUpdatingLocation()
    }
    
    fileprivate func handleNonAuthorizedLocation() {
        print("not authorized")
        let alert = UIAlertController(title: "Location Needed", message: "Sorry App can not detect your location please give location permission", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    /// location delegate methods
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if presentedViewController == nil {
            let alertController = UIAlertController(title: "Interesting Location Nearby", message: "You need to refresh you are out of \(region.identifier). Check it out!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default) {
                [weak self] action in
                self?.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            present(alertController, animated: false, completion: nil)
        }
        didExitFromRegion = true
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied, .restricted:
            handleNonAuthorizedLocation()
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //        let locationLatLong = "\(String(describing: location.coordinate.latitude)),\(String(describing: location.coordinate.longitude))"
        //        print(locationLatLong)
        
        let location = locations.first!
        if fetchedRegionCenter == nil {
            fetchedRegionCenter = location.coordinate
            if self.mode == .signle {
                disableLocationServies()
            }else if mode == .realTime{
                setupNewRegion()
            }
            
        }
    }
}
