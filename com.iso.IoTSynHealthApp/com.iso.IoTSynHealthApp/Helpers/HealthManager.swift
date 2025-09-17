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

    //MARK: request for month
    func fetchStepDataThisMonth(
        completion: @escaping ([(Date, Double)]) -> Void
    ) {
        let calendar = Calendar.current
        let now = Date()
        let range = calendar.range(of: .day, in: .month, for: now)!
        let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: now)
        )!

        let endOfMonth = calendar.date(
            byAdding: .day,
            value: range.count,
            to: startOfMonth
        )!

        fetchStatisticsPerDay(
            for: .stepCount,
            startDate: startOfMonth,
            endDate: endOfMonth
        ) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("❌ Failed to fetch monthly steps: \(error)")
                completion([])
            }
        }
    }

    func fetchStatisticsPerDay(
        for type: HealthDataType,
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<[(Date, Double)], Error>) -> Void
    ) {
        let quantityType = type.quantityType

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        var interval = DateComponents()
        interval.day = 1  // Lấy theo ngày

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: type.optionsHK,  // Sử dụng đúng option
            anchorDate: startDate,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            var data: [(Date, Double)] = []

            results?.enumerateStatistics(from: startDate, to: endDate) {
                statistics,
                _ in
                let value: Double
                switch type.optionsHK {
                case .discreteAverage:
                    value =
                        statistics.averageQuantity()?.doubleValue(
                            for: type.unit
                        ) ?? 0
                case .cumulativeSum:
                    value =
                        statistics.sumQuantity()?.doubleValue(for: type.unit)
                        ?? 0
                default:
                    value = 0
                }
                data.append((statistics.startDate, value))
            }

            completion(.success(data))
        }

        self.healthStore.execute(query)
    }

    func fetchStepData(
        type: HealthDataType,
        filter: TimeFilter,
        completion: @escaping ([(Date, Double)]) -> Void
    ) {
        let calendar = Calendar.current
        let now = Date()
        var startDate: Date
        var interval = DateComponents()

        switch filter {
        case .hour:
            startDate = calendar.date(bySetting: .minute, value: 0, of: now) ?? now
            interval.minute = 5
        case .day:
            startDate = calendar.startOfDay(for: now)
            interval.hour = 1
        case .month:
            startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) ?? now
            interval.day = 1
        case .year:
            startDate = calendar.date(from: calendar.dateComponents([.year], from: now)) ?? now
            interval.month = 1
        }

        fetchStatistics(
            for: type,
            startDate: startDate,
            endDate: now,
            interval: interval
        ) { result in
            switch result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("❌ Failed to fetch steps for \(filter): \(error)")
                completion([])
            }
        }
    }
    
    func fetchStatistics(
        for type: HealthDataType,
        startDate: Date,
        endDate: Date,
        interval: DateComponents,
        completion: @escaping (Result<[(Date, Double)], Error>) -> Void
    ) {
        let quantityType = type.quantityType

        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        let query = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: type.optionsHK,
            anchorDate: startDate,
            intervalComponents: interval
        )

        query.initialResultsHandler = { _, results, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            var data: [(Date, Double)] = []

            results?.enumerateStatistics(from: startDate, to: endDate) { stats, _ in
                let value: Double
                switch type.optionsHK {
                case .discreteAverage:
                    value = stats.averageQuantity()?.doubleValue(for: type.unit) ?? 0
                case .cumulativeSum:
                    value = stats.sumQuantity()?.doubleValue(for: type.unit) ?? 0
                default:
                    value = 0
                }
                data.append((stats.startDate, value))
            }

            completion(.success(data))
        }

        self.healthStore.execute(query)
    }
   // MARK: for view all data
    func fetchAllSamplesThisYear(
        for dataType: HealthDataType,
        completion: @escaping (Result<[HKQuantitySample], Error>) -> Void
    ) {
        let calendar = Calendar.current
        let now = Date()
        let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: now))!

        let predicate = HKQuery.predicateForSamples(
            withStart: startOfYear,
            end: now,
            options: .strictStartDate
        )

        let query = HKSampleQuery(
            sampleType: dataType.quantityType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [
                NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            ]
        ) { _, samples, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            let quantitySamples = samples as? [HKQuantitySample] ?? []
            completion(.success(quantitySamples))
        }

        healthStore.execute(query)
    }

}
