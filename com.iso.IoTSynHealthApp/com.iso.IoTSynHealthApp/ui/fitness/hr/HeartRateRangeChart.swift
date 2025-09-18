//
// Copyright © 2022 Swift Charts Examples.
// Open Source - MIT License

import Charts
import SwiftUI

struct HeartRateDayData: Identifiable {
    let id = UUID()
    let date: Date
    let dailyMin: Double
    let dailyMax: Double

    var weekdayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"  // T2, T3...
        return formatter.string(from: date)
    }
}

struct HeartRateRangeChart: View {
    let data: [HeartRateDayData]

    @State private var barWidth = 10.0
    @State private var chartColor: Color = .red

    var body: some View {
        Chart(data) { dataPoint in
            BarMark(
                x: .value("Day", dataPoint.weekdayString),
                yStart: .value("BPM Min", dataPoint.dailyMin),
                yEnd: .value("BPM Max", dataPoint.dailyMax),
                width: .fixed(barWidth)
            )
            .clipShape(Capsule())
            .foregroundStyle(chartColor.gradient)
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .frame(height: 300)
        .onAppear {
            print("📊 HeartRateRangeChart data:")
            for item in data {
                print(
                    """
                    - Date: \(item.date),
                      Min: \(item.dailyMin),
                      Max: \(item.dailyMax),
                      Label: \(item.weekdayString)
                    """
                )
            }
        }
    }
}
