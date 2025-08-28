//
//  HealthManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import HealthKit
import SwiftUI

//Time 1h32
class HealthManager {

    static let shared = HealthManager()
    let healthStore = HKHealthStore()

    private init() {
        let calories = HKQuantityType(.activeEnergyBurned)  //năng lượng hoạt động đã tiêu hao – tức là calo bạn đốt thông qua vận động
        let excercise = HKQuantityType(.appleExerciseTime)  //Thời gian bạn đã tập thể dục
        let stand = HKQuantityType(.appleStandTime)  //đứng dậy và di chuyển một chút trong mỗi giờ

        let healTypes: Set<HKQuantityType> = [calories, excercise, stand]

        Task {
            do {
                try await healthStore.requestAuthorization(
                    toShare: [],
                    read: healTypes
                )
            } catch {
                //                print("Failed to authorize health data: \(error)")
                print(error.localizedDescription)
            }
        }
    }
}
