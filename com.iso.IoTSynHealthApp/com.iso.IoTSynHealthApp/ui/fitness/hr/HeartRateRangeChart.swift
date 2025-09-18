import SwiftUI
import Charts

// MARK: - Model

struct HeartRateDayData: Identifiable {
    let id = UUID()
    let date: Date
    let dailyMin: Double
    let dailyMax: Double

    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

struct LabeledHeartRateData: Identifiable {
    let id = UUID()
    let date: Date
    let label: String
    let dailyMin: Double
    let dailyMax: Double
}

// MARK: - Main View

struct HeartRateRangeChart: View {
    let data: [HeartRateDayData]
    let filter: TimeFilter

    @State private var barWidth = 10.0
    @State private var chartColor: Color = .red

    var body: some View {
        Chart {
            ForEach(groupedData) { dataPoint in
//                if(dataPoint.dailyMin == 0){
//                    re
//                }
                if dataPoint.dailyMin == dataPoint.dailyMax  {
                    // min = max => vẽ 1 điẻm châm
                    PointMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Heart Rate", dataPoint.dailyMin)
                    )
                    .foregroundStyle(chartColor)
                } else {
                    BarMark(
                        x: .value("Time", dataPoint.date),
                        yStart: .value("Min", dataPoint.dailyMin),
                        yEnd: .value("Max", dataPoint.dailyMax),
                        width: .fixed(barWidth)
                    )
                    .clipShape(Capsule())
                    .foregroundStyle(chartColor.gradient)
                }
            }

        }
        .chartXAxis {
            switch filter {
            case .day:
                AxisMarks(values: .stride(by: .hour)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(hourFormatter.string(from: date))
                        }
                    }
                }

            case .week:
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            let weekdaySymbols = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                            let weekday = Calendar.current.component(.weekday, from: date)
                            Text(weekdaySymbols[(weekday + 5) % 7])
                        }
                    }
                }

            case .month:
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            let day = Calendar.current.component(.day, from: date)
                            Text("\(day)")
                        }
                    }
                }

            case .year:
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(monthFormatter.string(from: date))
                        }
                    }
                }
            }
        }
        .frame(height: 300)
        .onAppear {
            print("📊 HeartRateRangeChart data for filter: \(filter.rawValue)")
            for item in groupedData {
                print("- Label: \(item.label), Min: \(item.dailyMin), Max: \(item.dailyMax)")
            }
        }
    }

    // MARK: - Grouping Data

    private var groupedData: [LabeledHeartRateData] {
        let calendar = Calendar.current
        let now = Date()

        switch filter {
        case .day:
            let interval = 60  // 60 phút
            let totalSlots = 24 * 60 / interval
            let startOfDay = calendar.startOfDay(for: now)

            return (0..<totalSlots).map { index in
                let slotStart = calendar.date(byAdding: .minute, value: index * interval, to: startOfDay)!
                let slotEnd = calendar.date(byAdding: .minute, value: interval, to: slotStart)!

                let slotData = data.filter {
                    $0.date >= slotStart && $0.date < slotEnd &&
                    calendar.isDate($0.date, inSameDayAs: now)
                }

                let dailyMin = slotData.map { $0.dailyMin }.min() ?? 0
                let dailyMax = slotData.map { $0.dailyMax }.max() ?? 0

                print("Slot: \(hourFormatter.string(from: slotStart)) - count: \(slotData.count), Min: \(dailyMin), Max: \(dailyMax)")

                return LabeledHeartRateData(
                    date: slotStart,
                    label: hourFormatter.string(from: slotStart),
                    dailyMin: dailyMin,
                    dailyMax: dailyMax
                )
            }



        case .week:
            let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let weekdaySymbols = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]

            return (0..<7).map { offset in
                let date = calendar.date(byAdding: .day, value: offset, to: startOfWeek)!
                let label = weekdaySymbols[offset]

                let dayData = data.filter {
                    calendar.isDate($0.date, inSameDayAs: date)
                }

                let dailyMin = dayData.map { $0.dailyMin }.min() ?? 0
                let dailyMax = dayData.map { $0.dailyMax }.max() ?? 0

                return LabeledHeartRateData(
                    date: date,
                    label: label,
                    dailyMin: dailyMin,
                    dailyMax: dailyMax
                )
            }

        case .month:
            let numberOfDays = numberOfDaysIn2(month: now)
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!

            return (0..<numberOfDays).map { dayOffset in
                let date = calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth)!
                let label = "\(dayOffset + 1)"

                let value = data.first {
                    calendar.isDate($0.date, inSameDayAs: date)
                }

                return LabeledHeartRateData(
                    date: date,
                    label: label,
                    dailyMin: value?.dailyMin ?? 0,
                    dailyMax: value?.dailyMax ?? 0
                )
            }

        case .year:
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!

            return (0..<12).map { monthOffset in
                var comps = calendar.dateComponents([.year], from: now)
                comps.month = monthOffset + 1
                comps.day = 1
                let date = calendar.date(from: comps)!

                let value = data.first {
                    calendar.component(.month, from: $0.date) == monthOffset + 1
                }

                return LabeledHeartRateData(
                    date: date,
                    label: monthFormatter.string(from: date),
                    dailyMin: value?.dailyMin ?? 0,
                    dailyMax: value?.dailyMax ?? 0
                )
            }
        }
    }
}

// MARK: - Helpers

extension Date {
    func roundedToNearest(minutes: Int) -> Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let minute = comps.minute else { return self }
        let roundedMinute = (minute / minutes) * minutes
        var newComps = comps
        newComps.minute = roundedMinute
        newComps.second = 0
        return calendar.date(from: newComps) ?? self
    }
}

func numberOfDaysIn2(month date: Date) -> Int {
    let calendar = Calendar.current
    guard let range = calendar.range(of: .day, in: .month, for: date) else {
        return 30
    }
    return range.count
}

// MARK: - Date Formatters

private let hourFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    formatter.timeZone = .current
    return formatter
}()

private let monthFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "vi_VN")
    formatter.dateFormat = "MMM"
    formatter.timeZone = .current
    return formatter
}()

