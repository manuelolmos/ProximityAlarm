//
//  AlarmManager.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 08/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit

class AlarmManager: NSObject {

    func restore() -> Alarm? {
        var alarm: Alarm?
        let defaults = UserDefaults.standard
        if let data = defaults.object(forKey: Alarm.Key.alarm.rawValue) as? Data {
           alarm  = try? JSONDecoder().decode(Alarm.self, from: data)
        }
        return alarm
    }

    func delete(_ alarm: Alarm) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: Alarm.Key.alarm.rawValue)
        defaults.synchronize()
    }

    func save(_ alarm: Alarm) {
        let encodedData = try? JSONEncoder().encode(alarm)
        let defaults = UserDefaults.standard
        defaults.set(encodedData, forKey: Alarm.Key.alarm.rawValue)
        defaults.synchronize()
    }
}
