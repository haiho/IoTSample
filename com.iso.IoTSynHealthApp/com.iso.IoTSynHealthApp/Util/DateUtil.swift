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
