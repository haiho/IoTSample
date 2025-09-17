import AAInfographics
import Foundation

class ActivityDetailViewModel: ObservableObject {
    let healthManager = HealthManager.shared
    @Published var chartData: [(Date, Double)] = []
    @Published var chartModel: AAChartModel? = nil
    @Published var selectedFilter: TimeFilter = .day {
        didSet {
            loadData()
        }
    }

    @Published var isLoading = false

    let activity: Activity

    init(activity: Activity) {
        self.activity = activity
        loadData()
    }

    func loadData() {
        isLoading = true

        healthManager.fetchStepData(type: activity.type, filter: selectedFilter)
        { [weak self] data in
            guard let self = self else { return }

            DispatchQueue.main.async {
                // 🧠 Điền các cột trống bằng 0 nếu thiếu
                self.chartData = self.fillMissingData(for: data)
                self.isLoading = false
                self.generateChartModel()
            }
        }
    }

    // ✅ Bổ sung cột có giá trị = 0 nếu thiếu để không bị cột quá to
    private func fillMissingData(for original: [(Date, Double)]) -> [(
        Date, Double
    )] {
        var result: [(Date, Double)] = []
        let calendar = Calendar.current
        let now = Date()

        var unit: Calendar.Component
        var total: Int

        switch selectedFilter {
        case .hour:
            unit = .hour
            total = 24
        case .day:
            unit = .hour
            total = 24
        case .month:
            unit = .day
            total = numberOfDaysIn(month: now)
        case .year:
            unit = .month
            total = 12
        }

        let startDate: Date
        switch selectedFilter {
        case .hour, .day:
            startDate = calendar.startOfDay(for: now)
        case .month:
            startDate = calendar.date(
                from: calendar.dateComponents([.year, .month], from: now)
            )!
        case .year:
            startDate = calendar.date(
                from: calendar.dateComponents([.year], from: now)
            )!
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
        case .hour:
            formatter.dateFormat = "HH:mm"
        case .day:
            formatter.dateFormat = "HH'h'"
        case .month:
            formatter.dateFormat = "d"
        case .year:
            formatter.dateFormat = "MMM"
        }
        return formatter.string(from: date)
    }
}
