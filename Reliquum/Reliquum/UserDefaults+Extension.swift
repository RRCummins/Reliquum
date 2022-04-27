//
//  UserDefaults+Extension.swift
//  Reliquum
//
//  Created by Ryan Cummins on 4/25/22.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.widgetcacheplace")!
    }
}
