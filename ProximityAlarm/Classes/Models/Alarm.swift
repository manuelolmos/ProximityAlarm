//
//  Alarm.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 07/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import Foundation
import MapKit

struct Alarm {
    var finalDestination: CLLocation
    var triggerDistance: Float

    func shouldRing(location: CLLocation) -> Bool {
        return location.distance(from: finalDestination) < Double(triggerDistance)
    }
}
