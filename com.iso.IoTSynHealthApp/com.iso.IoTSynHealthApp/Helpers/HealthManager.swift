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
        Task {
            do {
                try await requestHealthkitAccess()
            } catch {
                //                print("Failed to authorize health data: \(error)")
                print(error.localizedDescription)
            }
        }
    }
    func requestHealthkitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)  //năng lượng hoạt động đã tiêu hao – tức là calo bạn đốt thông qua vận động
        let excercise = HKQuantityType(.appleExerciseTime)  //Thời gian bạn đã tập thể dục
        let stand = HKQuantityType(.appleStandTime)  //đứng dậy và di chuyển một chút trong mỗi giờ
        let stepType = HKQuantityType(.stepCount)
        
        let healTypes: Set<HKQuantityType> = [calories, excercise, stand,stepType]
        try await healthStore.requestAuthorization(
            toShare: [],
            read: healTypes
        )

    }

    func fetchTodayCaloriesBurned(
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        let calories = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(
            withStart: .startOfDay(),
            end: Date()
        )
        let query = HKStatisticsQuery(
            quantityType: calories,
            quantitySamplePredicate: predicate
        ) {
            _,
            result,
            error in

            guard let quantity = result?.sumQuantity(), error == nil else {
                completion(.failure(NSError()))
                return
            }
            let caloriesBurned = quantity.doubleValue(for: .kilocalorie())
            completion(.success(caloriesBurned))
        }

        healthStore.execute(query)

    }

}
