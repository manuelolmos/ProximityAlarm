//
//  ViewController.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 06/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, LocationDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private var locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        locationManager.delegate = self
    }

    func locationDidUpdate(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}
