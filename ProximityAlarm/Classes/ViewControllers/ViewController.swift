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
    private var actualAlarm: Alarm?
    private var locationManager = LocationManager()
    private var destinationPlacemark: MKPlacemark?
    private var soundPlayer = SoundPlayer()

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

    @IBAction func saveAlarmTUI(_ sender: Any) {
        guard distanceToTrigger > 0.0,
            let destination = destinationPlacemark,
            let destinationLocation = destination.location else {
                return
        }
        // TODO: Parse readable address
        let message = "Destination: \(destination)\nDistance to trigger alarm: \(distanceToTrigger)"
        let alertController = UIAlertController(
            title: "Alarm set",
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        actualAlarm = Alarm(finalDestination: destinationLocation, triggerDistance: distanceToTrigger)
        if let currentLocation = locationManager.currentLocation {
            triggerAlarmIfnecessary(location: currentLocation)
        }
    }

    private func triggerAlarmIfnecessary(location: CLLocation) {
        if let alarm = actualAlarm, alarm.shouldRing(location: location) {
            soundPlayer.play()
            actualAlarm = nil
        }
    }
}
