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
    @IBOutlet weak var finalPositionSliderLabel: UILabel!
    @IBOutlet weak var initPositionSliderLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    private let distanceToCover: Float = AppConfig.maxDistanceToTrigger
    private var distanceToTrigger: Float = 0.0
    private var locationManager = LocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        locationManager.delegate = self
        setupUIComponents()
    }

    func locationDidUpdate(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }

    private func setupUIComponents() {
        distanceLabel.text = "When to trigger alarm: \(distanceToCover*0.5)m"
        initPositionSliderLabel.text = "\(AppConfig.minDistanceToTrigger)m"
        finalPositionSliderLabel.text = "\(distanceToCover)m"
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        distanceToTrigger = round(sender.value*distanceToCover)
        distanceLabel.text = "When to trigger alarm: \(distanceToTrigger)m"
    }
}
