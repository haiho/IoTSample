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
    
    func roundedToNearest(minutes: Int, calendar: Calendar = .current) -> Date {
        let components = calendar.dateComponents([.hour, .minute], from: self)
        guard let hour = components.hour, let minute = components.minute else {
            return self
        }

        let totalMinutes = hour * 60 + minute
        let roundedMinutes = (totalMinutes / minutes) * minutes

        let roundedHour = roundedMinutes / 60
        let roundedMinute = roundedMinutes % 60

        var dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        dateComponents.hour = roundedHour
        dateComponents.minute = roundedMinute

        return calendar.date(from: dateComponents) ?? self
    }
}
func numberOfDaysIn(month date: Date) -> Int {
    let calendar = Calendar.current

    // Lấy ngày bắt đầu của tháng
    guard
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: date)
        ),
        // Lấy ngày đầu tháng kế tiếp
        let startOfNextMonth = calendar.date(
            byAdding: .month,
            value: 1,
            to: startOfMonth
        )
    else {
        return 30  // fallback
    }

    // Tính số ngày bằng số giây chia cho 86400
    let numberOfDays =
        calendar.dateComponents(
            [.day],
            from: startOfMonth,
            to: startOfNextMonth
        ).day ?? 30
    return numberOfDays
}

func formattedFullDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/yyyy HH:mm"
    return formatter.string(from: date)
}
