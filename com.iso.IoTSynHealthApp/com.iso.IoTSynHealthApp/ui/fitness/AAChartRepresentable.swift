//
//  AAChartRepresentable.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 17/9/25.
//

import SwiftUI
import AAInfographics

struct AAChartRepresentable: UIViewRepresentable {
    var chartModel: AAChartModel

    func makeUIView(context: Context) -> AAChartView {
        let chartView = AAChartView()
        chartView.isScrollEnabled = false
        chartView.isClearBackgroundColor = true
        return chartView
    }

    func updateUIView(_ uiView: AAChartView, context: Context) {
        uiView.aa_drawChartWithChartModel(chartModel)
    }
}
