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
                self.chartData = data
                self.isLoading = false
                self.generateChartModel()
            }
        }
    }

    private func generateChartModel() {
        // ✅ Lọc bỏ các giá trị có value == 0
        let filteredData = chartData.filter { $0.1 > 0 }

        guard !filteredData.isEmpty else {
            self.chartModel = nil
            return
        }

        let categories = filteredData.map { formatLabel(for: $0.0) }
        let values = filteredData.map { $0.1 }

        let aaOptions = AAOptions()

        aaOptions.chart = AAChart()
            .type(.column)

        aaOptions.title = AATitle()
            .text(activity.type.displayName)

        aaOptions.subtitle = AASubtitle()
            .text(selectedFilter.rawValue)

        aaOptions.xAxis = AAXAxis()
            .categories(categories)

        aaOptions.yAxis = AAYAxis()
            .title(AATitle().text(""))  // Ẩn tiêu đề trục Y

        aaOptions.plotOptions = AAPlotOptions()
            .column(
                AAColumn()
                    .pointWidth(10)  // Chiều rộng cố định của mỗi cột (pixel)
                    .borderWidth(0)
            )

        aaOptions.series = [
            AASeriesElement()
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
        ]

        // ⚠️ Lưu ý: AAChartModel chỉ là shortcut tạo AAOptions
        // Nhưng ở đây ta dùng trực tiếp AAOptions cho linh hoạt hơn
        let chartModel = AAChartModel()
            .chartType(.column)
            .categories(categories)
            .series([
                AASeriesElement()
                    .name(activity.type.displayName)
                    .data(values)
            ])

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
