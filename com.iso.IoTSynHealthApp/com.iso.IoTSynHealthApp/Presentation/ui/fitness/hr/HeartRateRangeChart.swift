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
    let startDate: Date
    let endDate: Date
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
        .chartXScale(domain: startDate...computedEndDate)
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
            AxisMarks(values: xAxisMonthMarks) { value in
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
            AxisMarks(values: xAxisYearMarks) { value in
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
    private var groupedData: [LabeledHeartRateData] {
        let calendar = Calendar.current
        switch filter {
        case .day:
            let interval = 10  // 10 phút
            let totalSlots = 24 * 60 / interval
            let startOfDay = calendar.startOfDay(for: startDate)

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
                        && calendar.isDate($0.date, inSameDayAs: startDate)
                }

                let dailyMin = slotData.map { $0.dailyMin }.min() ?? 0
                let dailyMax = slotData.map { $0.dailyMax }.max() ?? 0

                let lblTime = DateFormatter.with(format: DateFormatter.hourOnly)
                    .string(from: slotStart)

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
                    from: startDate
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
            let numberOfDays = numberOfDaysIn(month: startDate)
            let startOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: startDate)
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
                var comps = calendar.dateComponents([.year], from: startDate)
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

    // MARK: - Computed properties for X Axis Marks

    private var xAxisDayMarks: [Date] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: startDate)
        // 24h, mỗi 5 giờ 1 mốc để tránh quá dày
        return stride(from: 0, through: 24, by: 5).compactMap { hour in
            calendar.date(byAdding: .hour, value: hour, to: startOfDay)
        }
    }

    private var xAxisWeekMarks: [Date] {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: startDate
            )
        )!
        // 7 ngày trong tuần
        return (0..<7).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startOfWeek)
        }
    }

    private var xAxisMonthMarks: [Date] {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: startDate))!
        let numberOfDays = numberOfDaysIn(month: startDate)
        // Tạo các điểm mỗi 3 ngày một
        return stride(from: 0, to: numberOfDays, by: 3).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startOfMonth)
        }
    }

    private var xAxisYearMarks: [Date] {
        let calendar = Calendar.current
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: startDate))!
        // Tạo các điểm mỗi 2 tháng một
        return stride(from: 0, to: 12, by: 2).compactMap { monthOffset in
            calendar.date(byAdding: .month, value: monthOffset, to: startOfYear)
        }
    }


    private var computedEndDate: Date {
        let calendar = Calendar.current
        switch filter {
        case .day:
            return calendar.date(
                byAdding: .day,
                value: 1,
                to: calendar.startOfDay(for: startDate)
            )!
        case .week:
            guard
                let startOfWeek = calendar.date(
                    from: calendar.dateComponents(
                        [.yearForWeekOfYear, .weekOfYear],
                        from: startDate
                    )
                )
            else { return startDate }
            return calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        case .month:
            guard
                let startOfMonth = calendar.date(
                    from: calendar.dateComponents(
                        [.year, .month],
                        from: startDate
                    )
                )
            else { return startDate }
            return calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        case .year:
            guard
                let startOfYear = calendar.date(
                    from: calendar.dateComponents([.year], from: startDate)
                )
            else { return startDate }
            return calendar.date(byAdding: .year, value: 1, to: startOfYear)!
        }
    }

    // MARK: - Helper function

    private func numberOfDaysIn(month date: Date) -> Int {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }
}
