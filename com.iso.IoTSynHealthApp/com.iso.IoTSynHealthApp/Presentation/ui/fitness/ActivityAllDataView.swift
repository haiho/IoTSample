import HealthKit
import SwiftUI

struct ActivityAllDataView: View {
    @EnvironmentObject var navManager: MainNavigationManager
    let healthManager = HealthManager.shared

    let activity: Activity
    @State private var samples: [HKQuantitySample] = []
    @State private var isLoading = true

    var body: some View {
        BaseScrollVStrack {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if samples.isEmpty {
                Text("Không có dữ liệu")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                LazyVStack {
                    ForEach(samples, id: \.self) { sample in
                        HStack(spacing: 4) {
                            Text(formattedFullDateTime(sample.startDate))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(formattedValue(sample))
                                .font(.body)
                                .bold()
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .onAppear {
            fetchSamples()
            
        }
        .customNavigationBarStringValue(
            title: activity.title,
            backAction: {
                navManager.pop()
            }
        )
        .appScreenPadding()
    }

    private func fetchSamples() {
        isLoading = true
        healthManager.fetchAllSamplesThisYear(for: activity.type) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let samples):
                    self.samples = samples
                    print("✅ ActivityAllDataView fetched: \(samples)")
                case .failure(let error):
                    print("❌ Fetch failed: \(error)")
                    self.samples = []
                }
                isLoading = false
            }
        }
    }
    private func formattedValue(_ sample: HKQuantitySample) -> String {
        let value = sample.quantity.doubleValue(for: activity.type.unit)
        let unit = unitSymbol(for: activity.type)

        let formatted: String
        switch activity.type {
        case .stepCount, .excerciseTime:
            formatted = "\(Int(value))"  // Hiển thị số nguyên
        case .heartRate:
            formatted = "\(Int(round(value)))"  // Làm tròn và hiển thị nguyên
        case .activeEnergyBurned:
            formatted = String(format: "%.0f", value)  // Không có số lẻ
        case .oxygenSaturation:
            formatted = String(format: "%.1f", value)  // Cần số lẻ như 97.5%
        }

        return "\(formatted) \(unit)"
    }

    private func unitSymbol(for type: HealthDataType) -> String {
        switch type {
        case .heartRate:
            return "BPM"
        case .oxygenSaturation:
            return "%"
        default:
            return ""
        }
    }

}
