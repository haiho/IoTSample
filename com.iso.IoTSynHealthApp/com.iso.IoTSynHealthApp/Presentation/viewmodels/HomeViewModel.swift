//
//  HomeViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var calories: Int = 0
    @Published var excersiceTime: Int = 0
    @Published var showPermissionAlert = false
    @Published var errorMessage: String?
    private let mainUseCase: MainUseCase
    private var hasShownPermissionAlert = false
    let healthManager = HealthManager.shared

    @Published var activities: [Activity] = [
        Activity(
            type: .stepCount,
            title: "Steps",
            subTitle: "This Week",
            image: "figure.walk",
            tintColor: .blue
        ),
        Activity(
            type: .heartRate,
            title: "Heart Rate",
            subTitle: "This Week",
            image: "heart.fill",
            tintColor: .pink
        ),
        Activity(
            type: .oxygenSaturation,
            title: "Oxygen",
            subTitle: "This Week",
            image: "lungs.fill",
            tintColor: .purple
        ),
    ]

    init(mainUseCase: MainUseCase = DefaultMainUseCase()) {
        self.mainUseCase = mainUseCase
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                requestSynHealthDataToday()
            } catch {
                print("Error requestHealthKitAccess : \(error)")
            }
        }
    }

    func requestSynHealthDataToday() {
        hasShownPermissionAlert = false
        for type in HealthDataType.allCases {
            if type == .heartRate {
                healthManager.fetchLatestValueHeartRate(
                    startDate: .startOfYear
                ) { result in
                    self.handleHealthResult2(result, for: type)
                }
            } else {
                healthManager.fetchQuantitySum(for: type) { result in
                    self.handleHealthResult(result, for: type)
                }
            }
        }
    }

    private func handleHealthResult2(
        _ result: Result<HeartRateResult, Error>,
        for type: HealthDataType
    ) {
        switch result {
        case .success(let data):
            self.updateValuesFromHealthKit(for: type, value: data.value)
            print("\(type.displayName): \(data.value)")
            print("\(type.displayName) Recorded at: \(data.date)")
            loadAllDataToSyn()
        case .failure(let error):
            if type == HealthDataType.excerciseTime {
                print(
                    "\(type.displayName): - \(error.localizedDescription)"
                )
            } else {
                let nsError = error as NSError
                switch nsError.code {
                case 2, 3:  // bị từ chối quyền truy cập => open setting
                    print("Health data not available for \(type.displayName).")
                    if !self.hasShownPermissionAlert {
                        self.hasShownPermissionAlert = true
                        DispatchQueue.main.async {
                            print(" ===showPermissionAlert")
                            self.showPermissionAlert = true
                        }
                    }

                default:
                    print(
                        "\(type.displayName): - \(error.localizedDescription)"
                    )
                }
            }

        }
    }
    private func handleHealthResult(
        _ result: Result<Double, Error>,
        for type: HealthDataType
    ) {
        switch result {
        case .success(let value):
            self.updateValuesFromHealthKit(for: type, value: value)
            print("\(type.displayName): \(value)")
        case .failure(let error):
            if type == HealthDataType.excerciseTime {
                print(
                    "\(type.displayName): - \(error.localizedDescription)"
                )
            } else {
                let nsError = error as NSError
                switch nsError.code {
                case 2, 3:  // bị từ chối quyền truy cập => open setting
                    print("Health data not available for \(type.displayName).")
                    if !self.hasShownPermissionAlert {
                        self.hasShownPermissionAlert = true
                        DispatchQueue.main.async {
                            print(" ===showPermissionAlert")
                            self.showPermissionAlert = true
                        }
                    }

                default:
                    print(
                        "\(type.displayName): - \(error.localizedDescription)"
                    )
                }
            }

        }
    }

    func updateValuesFromHealthKit(for type: HealthDataType, value: Double) {
        switch type {
        case .excerciseTime:
            self.excersiceTime = Int(value)
        case .activeEnergyBurned:
            self.calories = Int(value)
        case .stepCount,
            .oxygenSaturation,
            .heartRate:
            updateActivityAmount(for: type, with: value)
        }
    }

    func updateActivityAmount(for type: HealthDataType, with value: Double) {
        if let activity = activities.first(where: { $0.type == type }) {
            activity.amount = "\(Int(value))"
        }
    }

    // api syndata to HDS on Cloud
    func syncHDSsampleFromIoTdevices(data: String) async throws
        -> GeneralResponse?
    {

        errorMessage = nil
        do {
            let response = try await mainUseCase.syncHDSsampleFromIoTdevices(
                data: data
            )
            return response
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    private func loadAllDataToSyn() {
        //        1. Load data from lastTimeSyn -> now

        healthManager.fetchAllSamplesFromDate2(
            from: .startOfYear,
            dataType: HealthDataType.heartRate
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let samples):
                    //       2. Syn to HDS
                    print("✅ ActivityAllDataView fetched: \(samples)")
                    self.synDataToHDS(results: samples)
                case .failure(let error):
                    print("❌ Fetch failed: \(error)")

                }
            }
        }

    }

    private func synDataToHDS(results: [(Date, Double)]) {
        let data: [DataObjMT] = results.map { (date, value) in
            DataObjMT(
                type: HealthDataType.heartRate.subsServerName,
                value: String(value),
                timestamp: date
            )
        }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted

            let jsonData = try encoder.encode(data)
            guard let jsonString = String(data: jsonData, encoding: .utf8)
            else {
                print("❌ Failed to convert JSON to String")
                return
            }

            Task {
                do {
                    let response =
                        try await mainUseCase.syncHDSsampleFromIoTdevices(
                            data: jsonString
                        )
                    print("✅ Server response: \(String(describing: response))")
                } catch {
                    print("❌ Sync error: \(error)")
                }
            }

        } catch {
            print("❌ JSON encode error: \(error)")
        }
    }

}
//1. check requestSynHealthDataToday lấy thời gian lastsyn để so sánh hds, và data today để hiển thị
//2. fetchLatestHeartRateForToday cần lấy last syn theo năm hay ngày ?
