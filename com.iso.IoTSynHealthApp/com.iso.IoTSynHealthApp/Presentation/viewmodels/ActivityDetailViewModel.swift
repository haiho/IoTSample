import AAInfographics
import Foundation
import HealthKit

class ActivityDetailViewModel: ObservableObject {
    let healthManager = HealthManager.shared
    @Published var chartData: [(Date, Double)] = []
    @Published var chartModel: AAChartModel? = nil
    @Published var isLoading = false
    let calendar = Calendar.current
    @Published var lblTimeFilter: String = ""
    let activity: Activity

    @Published var selectedFilter: TimeFilter = .day {
        didSet {
            dateOffset = 0
            loadData()
        }
    }

    @Published var dateOffset: Int = 0 {
        didSet {
            loadData()
        }
    }

    init(activity: Activity) {
        self.activity = activity
        loadData()
    }

    func loadData() {
        isLoading = true
        let range = selectedFilter.dateRange(
            using: calendar,
            offset: dateOffset
        )
        lblTimeFilter = selectedFilter.displayLabel(
            using: calendar,
            offset: dateOffset
        )

        if activity.type == .heartRate {
            healthManager.fetchHeartRateSamples(
                from: range.startDate,
                to: range.endDate
            ) { [weak self] samples, _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let samples = samples {
                        self.chartData = samples.map { sample in
                            let bpm = sample.quantity.doubleValue(
                                for: HKUnit.count().unitDivided(by: .minute())
                            )
                            return (sample.startDate, bpm)
                        }.sorted(by: { $0.0 < $1.0 })
                        self.chartModel = nil
                    } else {
                        self.chartData = []
                        self.chartModel = nil
                    }
                }
            }
        } else {
            healthManager.fetchStepData(
                type: activity.type,
                filter: selectedFilter,
                from: range.startDate,
                to: range.endDate
            ) { [weak self] data in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.chartData = self.fillMissingData(
                        for: data,
                        from : range.startDate
                    )
                    self.generateChartModel()
                    self.isLoading = false
                }
            }
        }
    }

    func goToPreviousFilter() {
        dateOffset -= 1
    }

    func goToNextFilter() {
        dateOffset += 1
    }

    func getDateRange(for filter: TimeFilter) -> (
        startDate: Date, endDate: Date
    ) {
        let calendar = Calendar.current
        let now = Date()
        var startDate: Date
        var endDate: Date

        switch filter {
        case .day:
            startDate = calendar.startOfDay(for: now)
            endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        case .week:
            startDate = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: now
                )
            )!
            endDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        case .month:
            startDate = calendar.date(
                from: calendar.dateComponents([.year, .month], from: now)
            )!
            endDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
        case .year:
            startDate = calendar.date(
                from: calendar.dateComponents([.year], from: now)
            )!
            endDate = calendar.date(byAdding: .year, value: 1, to: startDate)!
        }

        return (startDate, endDate)
    }

    private func fillMissingData(
        for original: [(Date, Double)],
        from startDate: Date
    ) -> [(
        Date, Double
    )] {
        var result: [(Date, Double)] = []
        var unit: Calendar.Component
        var total: Int

        switch selectedFilter {
        case .day:
            unit = .hour
            total = 24
        case .week:
            unit = .day
            total = 7
        case .month:
            unit = .day
            total = numberOfDaysIn(month: startDate)
        case .year:
            unit = .month
            total = 12
        }

        for i in 0..<total {
            if let date = calendar.date(byAdding: unit, value: i, to: startDate)
            {
                let value =
                    original.first(where: {
                        calendar.isDate(
                            $0.0,
                            equalTo: date,
                            toGranularity: unit
                        )
                    })?.1 ?? 0
                result.append((date, value))
            }
        }

        return result
    }

    private func generateChartModel() {
        // 🧹 Lọc để không hiển thị label nếu giá trị = 0 (vẫn hiển thị cột)
        let categories = chartData.map { formatLabel(for: $0.0) }
        let values = chartData.map { $0.1 }
        // Kiểm tra nếu tất cả đều bằng 0
        let allZero = values.allSatisfy { $0 == 0 }
        let subtitleText = allZero ? "Không có dữ liệu" : ""

        let series = AASeriesElement()
            .name(activity.type.displayName)
            .data(values)
            .dataLabels(
                AADataLabels()
                    .enabled(true)
                    .formatter(
                        """
                            function () {
                                return this.y == 0 ? null : this.y;
                            }
                        """
                    )
            )

        let chartModel = AAChartModel()
            .chartType(.column)
            .subtitle(subtitleText)
            .categories(categories)
            .dataLabelsEnabled(true)
            .colorsTheme(["#4A90E2"])
            .series([series])
            .animationType(.bounce)
            .yAxisTitle("")  // Ẩn tiêu đề trục Y
            .backgroundColor(AAColor.clear)

        self.chartModel = chartModel
    }

    private func formatLabel(for date: Date) -> String {
        let formatter = DateFormatter()
        switch selectedFilter {
        case .week:
            let weekday = Calendar.current.component(.weekday, from: date)
            // Chuyển weekday thành tên tiếng Việt: 1 = CN, 2 = T2, ...
            let names = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"]
            return names[(weekday - 1) % 7]
        case .day:
            formatter.dateFormat = "HH'h'"
        case .month:
            formatter.dateFormat = "d"
        case .year:
            formatter.dateFormat = "MMM"
        }
        return formatter.string(from: date)
    }

    func heartRateDayData() -> [HeartRateDayData] {
        let calendar = Calendar.current
        let filteredData = chartData.filter { $0.1 != 0 }

        let grouped: [Date: [(Date, Double)]]

        if selectedFilter == .day {
            // Nhóm theo block 10 phút nếu là chế độ "Ngày"
            grouped = Dictionary(
                grouping: filteredData,
                by: { date in
                    let components = calendar.dateComponents(
                        [.year, .month, .day, .hour, .minute],
                        from: date.0
                    )
                    let minute = (components.minute ?? 0) / 10 * 10
                    return calendar.date(
                        from: DateComponents(
                            year: components.year,
                            month: components.month,
                            day: components.day,
                            hour: components.hour,
                            minute: minute
                        )
                    ) ?? date.0
                }
            )
        } else {
            // Nhóm theo ngày cho các chế độ còn lại
            grouped = Dictionary(
                grouping: filteredData,
                by: { calendar.startOfDay(for: $0.0) }
            )
        }

        return grouped.map { (date, values) in
            let bpmValues = values.map { $0.1 }
            return HeartRateDayData(
                date: date,
                dailyMin: bpmValues.min() ?? 0,
                dailyMax: bpmValues.max() ?? 0
            )
        }
        .sorted { $0.date < $1.date }
    }

    // Hàm chuyển đổi ngày giờ sang timezone local và format thành String
    func formatDateToLocalString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.timeZone = TimeZone.current  // timezone local thiết bị
        return formatter.string(from: date)
    }

}
