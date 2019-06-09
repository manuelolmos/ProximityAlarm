//
//  ViewController.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 06/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finalPositionSliderLabel: UILabel!
    @IBOutlet weak var initPositionSliderLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    private let distanceToCover: Float = AppConfig.maxDistanceToTrigger
    private var distanceToTrigger: Float = 0.0
    private var actualAlarm: Alarm?
    private var locationManager = LocationManager()
    private var destinationPlacemark: MKPlacemark?
    private var soundPlayer = SoundPlayer()
    private var resultSearchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = LocationManager()
        locationManager.delegate = self
        actualAlarm = AlarmManager().restore()
        setupUIComponents()
        setupSearchController()
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
        let destinationText = AddressHelper().parseAddress(selectedItem: destination)
        let message = "Destination: \(destinationText)\nDistance to trigger alarm: \(distanceToTrigger)"
        let alertController = UIAlertController(
            title: "Alarm set",
            message: message,
            preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        let alarm = Alarm(destination: destinationLocation, distance: distanceToTrigger)
        actualAlarm = alarm
        AlarmManager().save(alarm)
        if let currentLocation = locationManager.currentLocation {
            triggerAlarmIfnecessary(location: currentLocation)
        }
    }

    private func setupSearchController() {
        let locationSearchTable = storyboard!.instantiateViewController(
            withIdentifier: "AddressSearchTableVC")
            as? AddressSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable?.mapView = mapView
        locationSearchTable?.mapSearchDelegate = self
    }

    private func setupUIComponents() {
        let triggerDistance = actualAlarm?.triggerDistance ?? distanceToCover*0.5
        slider.value = triggerDistance/distanceToCover
        distanceLabel.text = "When to trigger alarm: \(triggerDistance)m"
        initPositionSliderLabel.text = "\(AppConfig.minDistanceToTrigger)m"
        finalPositionSliderLabel.text = "\(distanceToCover)m"
    }

    private func triggerAlarmIfnecessary(location: CLLocation) {
        if let alarm = actualAlarm, alarm.shouldRing(location: location) {
            soundPlayer.play()
            AlarmManager().delete(alarm)
            actualAlarm = nil
        }
    }
}

extension ViewController: LocationDelegate {

    func locationDidUpdate(region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

extension ViewController: MapSearchDelegate {

    func addressSelected(placemark: MKPlacemark) {
        destinationPlacemark = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality, let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
