//
//  HealthManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import HealthKit
import SwiftUI

// Note: You need to enable both read & write permissions; otherwise, you won't be able to distinguish error code 11
// when the health type is either not authorized or has no data

enum HealthDataType {
    case stepCount
    case activeEnergyBurned
    var quantityType: HKQuantityType {
        switch self {
        case .stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)!
        case .activeEnergyBurned:
            return HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned
            )!
        }
    }

    var unit: HKUnit {
        switch self {
        case .stepCount:
            return .count()
        case .activeEnergyBurned:
            return .kilocalorie()
        }
    }
    var displayName: String {
        switch self {
        case .stepCount:
            return "Steps"
        case .activeEnergyBurned:
            return "Calories"
        }
    }
}

class HealthManager {

    static let shared = HealthManager()
    let healthStore = HKHealthStore()

    private init() {

    }

    func requestHealthKitAccess() async throws {
        let healthTypesToRead: Set<HKObjectType> = [
            HealthDataType.stepCount.quantityType,
            HealthDataType.activeEnergyBurned.quantityType,
        ]

        let typesToWrite: Set<HKSampleType> = [
            HealthDataType.stepCount.quantityType,
            HealthDataType.activeEnergyBurned.quantityType,
        ]

        try await healthStore.requestAuthorization(
            toShare: typesToWrite,
            read: healthTypesToRead
        )
    }
    // MARK: - Public Fetch Methods
    func fetchTodaySteps(completion: @escaping (Result<Double, Error>) -> Void)
    {
        fetchQuantitySum(for: .stepCount, completion: completion)
    }

    func fetchTodayCalories(
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        fetchQuantitySum(for: .activeEnergyBurned, completion: completion)
    }

    private func fetchQuantitySum(
        for dataType: HealthDataType,
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        checkPermission(for: dataType) { permissionResult in
            switch permissionResult {
            case .failure(let permissionError):
                DispatchQueue.main.async {
                    completion(.failure(permissionError))
                }
            case .success:
                let predicate = HKQuery.predicateForSamples(
                    withStart: .startOfDay(),
                    end: .nowDate(),
                    options: .strictStartDate
                )

                let query = HKStatisticsQuery(
                    quantityType: dataType.quantityType,
                    quantitySamplePredicate: predicate,
                    options: .cumulativeSum
                ) { _, result, _ in
                    let value =
                        result?.sumQuantity()?.doubleValue(for: dataType.unit)
                        ?? 0
                    DispatchQueue.main.async {
                        completion(.success(value))
                    }
                }

                self.healthStore.execute(query)
            }
        }
    }

    private func checkPermission(
        for healthDataType: HealthDataType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        switch healthStore.authorizationStatus(for: healthDataType.quantityType)
        {
        case .notDetermined:

            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 2,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "msg_per_request_health_app".localized

                        ]
                    )
                )
            )
        case .sharingDenied:
            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 3,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "msg_user_denied_health_app".localizedFormat(
                                    healthDataType.displayName
                                )
                        ]
                    )
                )
            )
        case .sharingAuthorized:
            completion(.success(()))
        @unknown default:
            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 4,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "msg_health_app_unknow_status".localized
                        ]
                    )
                )
            )
        }
    }

}
