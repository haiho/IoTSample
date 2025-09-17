//
//  ActivityDetailViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 17/9/25.
//

import Foundation
import AAInfographics

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
        healthManager.fetchStepData(type: activity.type, filter: selectedFilter) { [weak self] data in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.chartData = data
                self.isLoading = false
                self.generateChartModel()
            }
        }
    }

    private func generateChartModel() {
        let categories = chartData.map { formatLabel(for: $0.0) }
        let values = chartData.map { $0.1 }

        let series = AASeriesElement()
            .name(activity.type.displayName)
            .data(values)

        let chartModel = AAChartModel()
            .chartType(.column)
            .title(activity.type.displayName)
            .subtitle(selectedFilter.rawValue)
            .categories(categories)
            .dataLabelsEnabled(true)
            .series([series])

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
