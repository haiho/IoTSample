//
//  DateUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import SwiftUI

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: .now)
    }

    static func nowDate() -> Date {
        return Date()
    }
    // Used for charts where the day of the week is used: visually  M/T/W etc
    // (but we want VoiceOver to read out the full day)
    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"

        return formatter.string(from: self)
    }

}
func numberOfDaysIn(month date: Date) -> Int {
    let calendar = Calendar.current
    guard let range = calendar.range(of: .day, in: .month, for: date) else {
        return 30
    }
    return range.count
}
// MARK: - Date Formatters
extension DateFormatter {
    static let hourMinute = "HH:mm"
    static let fullDate = "dd/MM/yyyy"
    static let monthYear = "MMM yyyy"
    static let hourOnly = "H"
    static let dayOnly = "dd"
    static let weekdayOnly = "EEE" //T2, T3, CN nếu locale là vi_VN
    static let monthOnly = "MMM"
    
    static func with(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = .current
        formatter.locale = .current
        return formatter
    }
    static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "H"
        formatter.timeZone = .current
        return formatter
    }()
}

func formattedFullDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm"
    return formatter.string(from: date)
}

private let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "vi_VN")
    formatter.dateFormat = "MMM"
    formatter.timeZone = .current
    return formatter
}()
