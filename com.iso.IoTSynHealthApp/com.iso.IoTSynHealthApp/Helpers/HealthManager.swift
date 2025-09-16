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

enum HealthDataType: CaseIterable {
    case activeEnergyBurned
    case excerciseTime
    case stepCount
    case oxygenSaturation
    case heartRate

    var quantityType: HKQuantityType {
        switch self {
        case .excerciseTime:
            return HKQuantityType.quantityType(
                forIdentifier: .appleExerciseTime
            )!
        case .activeEnergyBurned:
            return HKQuantityType.quantityType(
                forIdentifier: .activeEnergyBurned
            )!

        case .stepCount:
            return HKQuantityType.quantityType(forIdentifier: .stepCount)!
        case .oxygenSaturation:
            return HKQuantityType.quantityType(
                forIdentifier: .oxygenSaturation
            )!
        case .heartRate:
            return HKQuantityType.quantityType(
                forIdentifier: .heartRate
            )!
        }

    }
    var optionsHK: HKStatisticsOptions {
        switch self {
        case .heartRate, .oxygenSaturation:  // dữ liệu rời rạc
            return .discreteAverage
        default:
            return .cumulativeSum
        }

    }

    var unit: HKUnit {
        switch self {
        case .activeEnergyBurned:
            return .kilocalorie()
        case .excerciseTime:
            return .minute()
        case .stepCount:
            return .count()
        case .oxygenSaturation:
            return .percent()
        case .heartRate:
            return HKUnit.count().unitDivided(by: .minute())  // beats per minute
        }
    }
    var displayName: String {
        switch self {
        case .excerciseTime:
            return "Excersice Time"
        case .activeEnergyBurned:
            return "Calories"
        case .stepCount:
            return "Steps"
        case .oxygenSaturation:
            return "Oxygen Saturation"
        case .heartRate:
            return "Heart Rate"

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
            HealthDataType.activeEnergyBurned.quantityType,
            HealthDataType.excerciseTime.quantityType,
            HealthDataType.stepCount.quantityType,
            HealthDataType.oxygenSaturation.quantityType,
            HealthDataType.heartRate.quantityType,

        ]

        let typesToWrite: Set<HKSampleType> = [
            HealthDataType.activeEnergyBurned.quantityType,
            //    HealthDataType.excerciseTime.quantityType, //only read, can not wire
            HealthDataType.stepCount.quantityType,
            HealthDataType.oxygenSaturation.quantityType,
            HealthDataType.heartRate.quantityType,

        ]

        try await healthStore.requestAuthorization(
            toShare: typesToWrite,
            read: healthTypesToRead
        )
    }
    // MARK: - Public Fetch Methods
    func fetchQuantitySum(
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
                    options: dataType.optionsHK
                ) { _, result, _ in

                    let value: Double
                    if dataType.optionsHK == .discreteAverage {
                        value =
                            result?.averageQuantity()?.doubleValue(
                                for: dataType.unit
                            ) ?? 0
                    } else {
                        value =
                            result?.sumQuantity()?.doubleValue(
                                for: dataType.unit
                            ) ?? 0
                    }
                    DispatchQueue.main.async {
                        completion(.success(value))
                    }
                }

                self.healthStore.execute(query)
            }
        }
    }

    // MARK: - Fetch Latest Heart Rate Sample
    func fetchLatestHeartRateForToday(
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        let dataType = HealthDataType.heartRate

        checkPermission(for: dataType) { permissionResult in
            switch permissionResult {
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }

            case .success:
                let sortDescriptor = NSSortDescriptor(
                    key: HKSampleSortIdentifierStartDate,
                    ascending: false
                )
                let predicate = HKQuery.predicateForSamples(
                    withStart: .startOfDay(),
                    end: .nowDate(),
                    options: .strictStartDate
                )
                // predicate mà để nil thì return giá trị cuối cùng, không phải trong ngày hôm đó
                // muốn lấy lastest value trong ngày cần có predicate

                let query = HKSampleQuery(
                    sampleType: dataType.quantityType,
                    predicate: predicate,
                    limit: 1,
                    sortDescriptors: [sortDescriptor]
                ) { _, samples, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                        return
                    }

                    guard let sample = samples?.first as? HKQuantitySample
                    else {
                        DispatchQueue.main.async {
                            completion(
                                .failure(
                                    NSError(
                                        domain: "HealthQuery",
                                        code: 10,
                                        userInfo: [
                                            NSLocalizedDescriptionKey:
                                                "health_sampe_no_data"
                                                .localizedFormat(
                                                    HealthDataType.heartRate
                                                        .displayName
                                                )
                                        ]
                                    )
                                )
                            )
                        }
                        return
                    }

                    let heartRateValue = sample.quantity.doubleValue(
                        for: dataType.unit
                    )

                    DispatchQueue.main.async {
                        completion(.success(heartRateValue))
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

        switch healthStore.authorizationStatus(
            for: healthDataType.quantityType
        )
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
                                "msg_user_denied_health_app"
                                .localizedFormat(
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
