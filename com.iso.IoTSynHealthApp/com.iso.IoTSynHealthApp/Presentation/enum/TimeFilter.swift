//
//  TimeFilter.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 17/9/25.
//
import SwiftUI
enum TimeFilter: String, CaseIterable {
    case day = "Ngày"
    case week = "Tuần"
    case month = "Tháng"
    case year = "Năm"
}

extension TimeFilter {
    func dateRange(
        using calendar: Calendar = .current,
        reference: Date = Date(),
        offset: Int = 0
    ) -> (startDate: Date, endDate: Date) {
        let shiftedDate: Date
        switch self {
        case .day:
            shiftedDate = calendar.date(byAdding: .day, value: offset, to: reference)!
        case .week:
            shiftedDate = calendar.date(byAdding: .weekOfYear, value: offset, to: reference)!
        case .month:
            shiftedDate = calendar.date(byAdding: .month, value: offset, to: reference)!
        case .year:
            shiftedDate = calendar.date(byAdding: .year, value: offset, to: reference)!
        }

        switch self {
        case .day:
            let start = calendar.startOfDay(for: shiftedDate)
            let end = calendar.date(byAdding: .day, value: 1, to: start)!
            return (start, end)

        case .week:
            let start = calendar.date(from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: shiftedDate
            ))!
            let end = calendar.date(byAdding: .day, value: 7, to: start)!
            return (start, end)

        case .month:
            let start = calendar.date(from: calendar.dateComponents([.year, .month], from: shiftedDate))!
            let end = calendar.date(byAdding: .month, value: 1, to: start)!
            return (start, end)

        case .year:
            let start = calendar.date(from: calendar.dateComponents([.year], from: shiftedDate))!
            let end = calendar.date(byAdding: .year, value: 1, to: start)!
            return (start, end)
        }
    }

    func displayLabel(
        using calendar: Calendar = .current,
        reference: Date = Date(),
        offset: Int = 0
    ) -> String {
        let (start, end) = self.dateRange(using: calendar, reference: reference, offset: offset)
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent

        switch self {
        case .day:
            formatter.dateFormat = "dd/MM/yyyy"
            return "\(formatter.string(from: start))"

        case .week:
            formatter.dateFormat = "dd/MM/yyyy"
            let toDate = calendar.date(byAdding: .day, value: -1, to: end)!
            return "\(formatter.string(from: start)) - \(formatter.string(from: toDate))"

        case .month:
            formatter.dateFormat = "LLLL"
            let monthName = formatter.string(from: start).capitalized(with: formatter.locale)
            return "\(monthName)"

        case .year:
            let year = calendar.component(.year, from: start)
            return "\(year)"
        }
    }
}
