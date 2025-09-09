//
//  DateUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import SwiftUI

extension Date {

    static func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date())
    }
    static func nowDate() -> Date {
        return Date()
    }
}
