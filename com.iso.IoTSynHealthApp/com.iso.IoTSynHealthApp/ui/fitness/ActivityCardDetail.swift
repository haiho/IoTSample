import AAInfographics
import SwiftUI

struct ActivityCardDetail: View {
    @StateObject var viewModel: ActivityDetailViewModel
    @EnvironmentObject var navManager: MainNavigationManager
    init(activity: Activity) {
        _viewModel = StateObject(
            wrappedValue: ActivityDetailViewModel(activity: activity)
        )
    }

    var body: some View {
        BaseScrollVStrack {
            Picker("Khoảng thời gian", selection: $viewModel.selectedFilter) {
                ForEach(TimeFilter.allCases, id: \.self) { filter in
                    Text(filter.rawValue).tag(filter)
                }
            }
            .pickerStyle(.segmented)

            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(height: 300)

                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.activity.type == .heartRate {
                    
                    HeartRateRangeChart(data: viewModel.heartRateDayData())
                } else {
                    if let chartModel = viewModel.chartModel {
                        AAChartRepresentable(chartModel: chartModel)
                            .frame(height: 300)
                    } else {
                        Text("Không có dữ liệu")
                            .foregroundColor(.gray)
                    }

                }

                if viewModel.isLoading {
                    ProgressView()
                }
            }

            if !viewModel.chartData.isEmpty {
                CustomButton(title: "lbl_view_all_data") {
                    navManager.push(.viewAllData(activity: viewModel.activity))
                }.padding(.top)
            }

        }.customNavigationBarStringValue(
            title: viewModel.activity.title,
            backAction: {
                navManager.pop()
            }
        ).appScreenPadding()
    }
}
