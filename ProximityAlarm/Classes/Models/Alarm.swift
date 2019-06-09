//
//  Alarm.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 07/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import Foundation
import MapKit

class Alarm: Codable {

    enum Key: String {
        case alarm
    }

    private var finalDestinationLongitude: Double
    private var finalDestinationLatitude: Double
    var triggerDistance: Float

    var finalDestination: CLLocation {
        return CLLocation(latitude: finalDestinationLatitude, longitude: finalDestinationLongitude)
    }

    init(destination: CLLocation, distance: Float) {
        finalDestinationLongitude = destination.coordinate.longitude
        finalDestinationLatitude = destination.coordinate.latitude
        triggerDistance = distance
    }

    func shouldRing(location: CLLocation) -> Bool {
        return location.distance(from: finalDestination) < Double(triggerDistance)
    }
}
