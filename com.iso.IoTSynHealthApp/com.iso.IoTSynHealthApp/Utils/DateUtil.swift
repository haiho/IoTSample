//
//  DateUtil.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import SwiftUI

extension Date {

    static func nowDate() -> Date {
        return Date()
    }
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: .now)
    }

    static var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: Date())
        return calendar.date(from: components)!
    }

    static var startOfYear: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: Date())
        return calendar.date(from: components)!
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
    static let formatDateUtc = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let hourMinute = "HH:mm"
    static let fullDate = "dd/MM/yyyy"
    static let monthYear = "MMM yyyy"
    static let hourOnly = "H"
    static let dayOnly = "dd"
    static let weekdayOnly = "EEE"  //T2, T3, CN nếu locale là vi_VN
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

func parseDate(
    from dateString: String?,
    format: String = DateFormatter.formatDateUtc
) -> Date? {
    guard let dateString = dateString, !dateString.isEmpty else {
        return nil
    }
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.date(from: dateString)
}
