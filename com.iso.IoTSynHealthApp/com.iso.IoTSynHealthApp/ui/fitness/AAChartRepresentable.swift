import SwiftUI
import AAInfographics

struct AAChartRepresentable: UIViewRepresentable {
    let chartModel: AAChartModel

    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.isScrollEnabled = false
        chartView.isClearBackgroundColor = true
        chartView.aa_drawChartWithChartModel(chartModel)
        return chartView
    }

    func updateUIView(_ uiView: AAChartView, context: Context) {
        uiView.aa_refreshChartWholeContentWithChartModel(chartModel)
    }
}
