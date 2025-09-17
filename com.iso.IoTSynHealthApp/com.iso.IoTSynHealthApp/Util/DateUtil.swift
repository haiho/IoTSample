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
extension DateFormatter {
    static func formatLabel(for date: Date, filter: TimeFilter) -> String {
        let formatter = DateFormatter()

        switch filter {
        case .hour:
            formatter.dateFormat = "HH:mm"
        case .day:
            formatter.dateFormat = "HH'h'"
        case .month:
            formatter.dateFormat = "dd/MM"
        case .year:
            formatter.dateFormat = "MMM"
        }

        return formatter.string(from: date)
    }
}
