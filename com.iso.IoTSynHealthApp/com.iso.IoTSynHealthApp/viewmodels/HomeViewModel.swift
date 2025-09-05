//
//  HomeViewModel.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @State var calories: Int = 222
    @State var steps: Int = 888999
    @State var activity: Int = 52
    @State var stand: Int = 8

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

    func checkPer() {
        healthManager.requestAuthorization { success, error in
            if success {
                self.healthManager.fetchStepCount { result in
                    switch result {
                    case .success(let calories):
                        print("Calories burned today: \(calories)")
                    case .failure(let error):
                        print(
                            "Error fetching calories: \(error.localizedDescription)"
                        )
                    }
                }
            } else {
                print(
                    "HealthKit authorization failed: \(error.localizedDescription)"
                )
            }
        }
    }
}
