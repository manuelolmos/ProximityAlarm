//
//  Alarm.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 07/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import Foundation
import MapKit

class Alarm: NSObject, Codable {

    enum Key: String {
        case alarm
    }

    private var finalDestinationLongitude: Double
    private var finalDestinationLatitude: Double
    var triggerDistance: Float
    var destinationAddress: String

    var finalDestination: CLLocation {
        return CLLocation(latitude: finalDestinationLatitude, longitude: finalDestinationLongitude)
    }

    init(destination: CLLocationCoordinate2D, distance: Float, address: String) {
        finalDestinationLongitude = destination.longitude
        finalDestinationLatitude = destination.latitude
        triggerDistance = distance
        destinationAddress = address
    }

    override var description: String {
        return "Destination: \(destinationAddress)\nDistance to trigger alarm: \(triggerDistance)\n"
    }

    func distanceToDestination(location: CLLocation) -> CLLocationDistance {
        return location.distance(from: finalDestination)
    }

    func shouldRing(location: CLLocation) -> Bool {
        return distanceToDestination(location: location) < Double(triggerDistance)
    }
}
