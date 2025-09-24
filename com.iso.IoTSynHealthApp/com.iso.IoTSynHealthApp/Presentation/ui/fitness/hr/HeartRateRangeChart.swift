import Charts
import SwiftUI

// MARK: - Model

struct HeartRateDayData: Identifiable {
    let id = UUID()
    let date: Date
    let dailyMin: Double
    let dailyMax: Double
}

struct LabeledHeartRateData: Identifiable, Equatable {
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

    // -- Thêm State để lưu data được chọn và vị trí tooltip --
    @State private var selectedData: LabeledHeartRateData? = nil
    @State private var tooltipPosition: CGPoint = .zero

    var body: some View {
        Chart {
            ForEach(groupedData) { dataPoint in
                if dataPoint.dailyMin == dataPoint.dailyMax {
                    if dataPoint.dailyMin == 0 {
                        PointMark(
                            x: .value("Time", dataPoint.date),
                            y: .value("Heart Rate", 0)
                        )
                        .foregroundStyle(Color.clear)
                    } else {
                        PointMark(
                            x: .value("Time", dataPoint.date),
                            y: .value("Heart Rate", dataPoint.dailyMin)
                        )
                        .foregroundStyle(chartColor)
                    }
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
            chartXAxisView()
        }
        .frame(height: 300)
        .chartOverlay { proxy in
            // -- Thêm phần chartOverlay để bắt gesture và hiển thị tooltip --
            chartOverlayView(proxy: proxy)
        }

    }

    //MARK: config lable x axis
    func chartXAxisView() -> some AxisContent {
        switch filter {
        case .day:
            AxisMarks(values: xAxisDayMarks) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(
                            DateFormatter.with(format: DateFormatter.hourOnly)
                                .string(from: date)
                        )
                    }
                }
            }
        case .week:
            AxisMarks(values: xAxisWeekMarks) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(
                            DateFormatter.with(
                                format: DateFormatter.weekdayOnly
                            ).string(from: date)
                        )
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
                        Text(
                            DateFormatter.with(format: DateFormatter.monthOnly)
                                .string(from: date)
                        )
                    }
                }
            }
        }
    }

    //MARK: drawn tooltips
    @ViewBuilder
    private func chartOverlayView(proxy: ChartProxy)
        -> some View
    {
        GeometryReader { geo in
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let location = value.location
                            tooltipPosition = location

                            // Convert vị trí x -> ngày gần nhất
                            if let date: Date = proxy.value(atX: location.x) {
                                // Tìm data gần nhất
                                if let closest = groupedData.min(by: {
                                    abs(
                                        $0.date.timeIntervalSince1970
                                            - date.timeIntervalSince1970
                                    )
                                        < abs(
                                            $1.date.timeIntervalSince1970
                                                - date.timeIntervalSince1970
                                        )
                                }),
                                    closest.dailyMin != 0
                                        || closest.dailyMax != 0
                                {
                                    // ✅ Chỉ gán nếu có giá trị thực
                                    withAnimation {
                                        selectedData = closest
                                    }
                                } else {
                                    // ❌ Nếu là 0, xoá tooltip
                                    selectedData = nil
                                }
                            }
                        }
                        .onEnded { _ in
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + 3
                            ) {
                                selectedData = nil
                            }
                        }
                )

            // ✅ Tooltip chỉ hiển thị khi selectedData khác nil
            if let data = selectedData {
                VStack(spacing: 4) {
                    //                        Text("\(data.label)")
                    //                            .font(.caption)
                    if data.dailyMin == data.dailyMax {
                        Text("\(Int(data.dailyMin))")
                            .font(.caption2)
                    } else {
                        Text("Min: \(Int(data.dailyMin))")
                            .font(.caption2)
                        Text("Max: \(Int(data.dailyMax))")
                            .font(.caption2)
                    }

                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .position(
                    x: tooltipPosition.x,
                    y: max(tooltipPosition.y - 40, 20)
                )
                .animation(.easeInOut, value: selectedData)
            }

        }
    }

    // MARK: - Grouping Data
    // Note :  viewModel.heartRateDayData() => group data by time
    private var groupedData: [LabeledHeartRateData] {
        let calendar = Calendar.current
        let now = Date()

        switch filter {
        case .day:
            let interval = 10  // 30 phút
            let totalSlots = 24 * 60 / interval
            let startOfDay = calendar.startOfDay(for: now)

            return (0..<totalSlots).map { index in
                let slotStart = calendar.date(
                    byAdding: .minute,
                    value: index * interval,
                    to: startOfDay
                )!
                let slotEnd = calendar.date(
                    byAdding: .minute,
                    value: interval,
                    to: slotStart
                )!

                let slotData = data.filter {
                    $0.date >= slotStart && $0.date < slotEnd
                        && calendar.isDate($0.date, inSameDayAs: now)
                }

                let dailyMin = slotData.map { $0.dailyMin }.min() ?? 0
                let dailyMax = slotData.map { $0.dailyMax }.max() ?? 0

                let lblTime = DateFormatter.with(format: DateFormatter.hourOnly)
                    .string(from: slotStart)
                //
                //                print(
                //                    "Slot: \(lblTime) - count: \(slotData.count), Min: \(dailyMin), Max: \(dailyMax)"
                //                )

                return LabeledHeartRateData(
                    date: slotStart,
                    label: lblTime,
                    dailyMin: dailyMin,
                    dailyMax: dailyMax
                )
            }

        case .week:
            let startOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: now
                )
            )!
            let weekdaySymbols = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]

            return (0..<7).map { offset in
                let date = calendar.date(
                    byAdding: .day,
                    value: offset,
                    to: startOfWeek
                )!
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
            let numberOfDays = numberOfDaysIn(month: now)
            let startOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: now)
            )!

            return (0..<numberOfDays).map { dayOffset in
                let date = calendar.date(
                    byAdding: .day,
                    value: dayOffset,
                    to: startOfMonth
                )!
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
            return (0..<12).map { monthOffset in
                var comps = calendar.dateComponents([.year], from: now)
                comps.month = monthOffset + 1
                comps.day = 1
                let date = calendar.date(from: comps)!

                let value = data.first {
                    calendar.component(.month, from: $0.date) == monthOffset + 1
                }
                let lblTime = DateFormatter.with(
                    format: DateFormatter.monthOnly
                ).string(from: date)

                return LabeledHeartRateData(
                    date: date,
                    label: lblTime,
                    dailyMin: value?.dailyMin ?? 0,
                    dailyMax: value?.dailyMax ?? 0
                )
            }
        }
    }
}

private var xAxisDayMarks: [Date] {
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: Date())
    //Trả về 24h trong ngày
    return stride(from: 0, through: 24, by: 5).compactMap { hour in
        calendar.date(byAdding: .hour, value: hour, to: startOfDay)
    }
}

private var xAxisWeekMarks: [Date] {
    let calendar = Calendar.current
    let now = Date()

    // Lấy ngày đầu tuần (thứ 2)
    let startOfWeek = calendar.date(
        from: calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: now
        )
    )!

    // Trả về 7 ngày trong tuần
    return (0..<8).compactMap { offset in
        calendar.date(byAdding: .day, value: offset, to: startOfWeek)
    }
}
