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

    @Published var activities: [Activity] = [
        //        Activity(
        //            type: .activeEnergyBurned,
        //            title: "Calories",
        //            subTitle: "This Week",
        //            image: "flame.fill",
        //            tintColor: .red
        //        ),
        //        Activity(
        //            type: .excerciseTime,
        //            title: "Exercise Time",
        //            subTitle: "This Week",
        //            image: "figure.run",
        //            tintColor: .green
        //        ),
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

    private var hasShownPermissionAlert = false  // <- Biến cờ nội bộ
    let healthManager = HealthManager.shared

    init() {
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
                healthManager.fetchLatestHeartRateForToday { result in
                    self.handleHealthResult(result, for: type)
                }
            } else {
                healthManager.fetchQuantitySum(for: type) { result in
                    self.handleHealthResult(result, for: type)
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

}
