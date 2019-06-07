//
//  LocationManager.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 06/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import Foundation
import MapKit

protocol LocationDelegate: class {
    func locationDidUpdate(region: MKCoordinateRegion)
}
class LocationManager: NSObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    weak var delegate: LocationDelegate?

    var currentLocation: CLLocation? {
        return locationManager.location
    }

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            delegate?.locationDidUpdate(region: region)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
}
