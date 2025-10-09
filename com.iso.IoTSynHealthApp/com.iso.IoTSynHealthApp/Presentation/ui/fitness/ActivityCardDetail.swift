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
            // HStack hiển thị thời gian + nút điều hướng
            HStack {
                Button(action: {
                    viewModel.goToPreviousFilter()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                }

                Spacer()

                CustomText(viewModel.lblTimeFilter)
                    .fontNormalBold
                    .color(.blue)
                    .centerAligned

                Spacer()

                Button(action: {
                    viewModel.goToNextFilter()
                }) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .padding()
                }
            }
            .padding(.horizontal)

            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(height: 300)

                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.activity.type == .heartRate {
                    HeartRateRangeChart(
                        startDate: viewModel.startDate,
                        data: viewModel.heartRateDayData(),
                        filter: viewModel.selectedFilter
                    )
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
