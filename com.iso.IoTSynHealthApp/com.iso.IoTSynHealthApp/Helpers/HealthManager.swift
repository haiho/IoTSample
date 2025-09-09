//
//  HealthManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import HealthKit
import SwiftUI

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

        try await healthStore.requestAuthorization(
            toShare: [],
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

    // MARK: - Private: Shared Fetch Logic
    private func fetchQuantitySum(
        for dataType: HealthDataType,
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        let predicate = HKQuery.predicateForSamples(
            withStart: .startOfDay(),
            end: .nowDate(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: dataType.quantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [weak self] _, result, error in
            guard let self else { return }

            if let quantity = result?.sumQuantity(), error == nil {
                let value = quantity.doubleValue(for: dataType.unit)
                DispatchQueue.main.async {
                    completion(.success(value))
                }
            } else {
                self.handleHealthError(
                    for: dataType,
                    fallbackError: error,
                    completion: completion
                )
            }
        }

        healthStore.execute(query)
    }

    // MARK: - Private: Permission & Error Handling
    private func handleHealthError(
        for healthDataType: HealthDataType,
        fallbackError: Error?,
        completion: @escaping (Result<Double, Error>) -> Void
    ) {
        let defaultError =
            fallbackError
            ?? NSError(
                domain: "HealthQuery",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Không thể lấy dữ liệu."]
            )

        checkPermission(for: healthDataType) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let permissionError):
                    completion(.failure(permissionError))
                case .success:
                    completion(.failure(defaultError))
                }
            }
        }
    }

    private func checkPermission(
        for healthDataType: HealthDataType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch healthStore.authorizationStatus(for: healthDataType.quantityType) {
        case .notDetermined:
            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 2,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Quyền truy cập HealthKit chưa được yêu cầu."
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
                                "Người dùng đã từ chối quyền truy cập \(healthDataType.displayName)"
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
                                "Trạng thái quyền truy cập không xác định."
                        ]
                    )
                )
            )
        }
    }

}
