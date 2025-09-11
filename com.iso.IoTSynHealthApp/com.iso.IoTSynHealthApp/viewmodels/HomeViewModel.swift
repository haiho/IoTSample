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
        healthManager.fetchTodayCalories {
            result in
            switch result {
            case .success(let calories):
                print("Success Caloires: \(calories)")
            case .failure(let error):
                print(
                    "Lỗi fetchTodayCaloriesBurned: \(error.localizedDescription)"
                )
            }
        }
        healthManager.fetchTodaySteps { result in
            switch result {
            case .success(let steps):
                print("Số bước hôm nay: \(steps)")
            case .failure(let error):
                print("Lỗi fetchStepCount: \(error.localizedDescription)")
            }
        }
    }
}
