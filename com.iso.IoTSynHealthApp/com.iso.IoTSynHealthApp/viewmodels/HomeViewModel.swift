//
//  HomeViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var calories: Int = 0
    @Published var steps: Int = 0
    @Published var activity: Int = 0
    @Published var oxySaturation: Int = 0
    @Published var showPermissionAlert = false

    private var hasShownPermissionAlert = false  // <- Biến cờ nội bộ
    let healthManager = HealthManager.shared

    let mockActivity = [
        Activity(
            id: 0,
            title: "Today Calories",
            subTitle: "Goal 12000",
            image: "figure.walk",
            tintColor: .green,
            amount: "9800"
        ),
        Activity(
            id: 1,
            title: "Today Activity",
            subTitle: "Goal 12000",
            image: "figure.run",
            tintColor: .purple,
            amount: "9800"
        ),
        Activity(
            id: 2,
            title: "Today Steps",
            subTitle: "Goal 12000",
            image: "figure.walk",
            tintColor: .blue,
            amount: "9800"
        ),
        Activity(
            id: 3,
            title: "Today Stand",
            subTitle: "Goal 12000",
            image: "figure.walk",
            tintColor: .red,
            amount: "9800"
        ),
    ]

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
            healthManager.fetchQuantitySum(for: type) { result in
                switch result {
                case .success(let value):
                    self.updateValuesFromHealthKit(for: type, value: value)
                    print("\(type.displayName): \(value)")
                case .failure(let error):
                    let nsError = error as NSError
                    switch nsError.code {
                    case 2, 3:  // bị từ chối quyền truy cập => open setting
                        print("Health data not available.")
                        if !self.hasShownPermissionAlert {
                            self.hasShownPermissionAlert = true
                            DispatchQueue.main.async {
                                print(" ===showPermissionAlert")
                                self.showPermissionAlert = true
                            }
                        }

                    default:
                        print(
                            "\(type.displayName): lỗi - \(error.localizedDescription)"
                        )
                    }
                }
            }
        }
    }

    func updateValuesFromHealthKit(for type: HealthDataType, value: Double) {
        switch type {
        case .stepCount:
            self.steps = Int(value)
        case .activeEnergyBurned:
            self.calories = Int(value)
        case .oxygenSaturation:
            self.oxySaturation = Int(value)
        }
    }

}
