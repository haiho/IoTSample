//
//  HealthManager.swift
//  com.iso.IoTSynHealthApp
//
//  Created by PTV on 28/8/25.
//

import HealthKit
import SwiftUI

class HealthManager {

    static let shared = HealthManager()
    let healthStore = HKHealthStore()

    private init() {
    }

    func requestAuthorization(
        completion: @escaping (Bool, Error) -> Void
    ) {
        guard
            let stepType = HKQuantityType.quantityType(
                forIdentifier: .stepCount

            )
        else {
            print("Không thể tạo stepCount type.")
            return
        }
        let status = healthStore.authorizationStatus(for: stepType)

        switch status {
        case .notDetermined:
            // Chưa xin quyền, tiến hành xin
            healthStore.requestAuthorization(toShare: nil, read: [stepType]) {
                success,
                error in
                DispatchQueue.main.async {
                    completion(
                        success,  // need to show msg don't allow permission
                        error
                            ?? NSError(
                                domain: "HealthAuth",
                                code: 1,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Không được cấp quyền HealthKit."
                                ]
                            )
                    )

                }
            }

        case .sharingDenied:
            // Người dùng đã từ chối quyền → hiển thị cảnh báo và hướng dẫn mở Settings
            DispatchQueue.main.async {
                //                      showHealthPermissionAlert()
                let error = NSError(
                    domain: "HealthAuth",
                    code: 2,
                    userInfo: [
                        NSLocalizedDescriptionKey:
                            "Người dùng đã từ chối quyền Health."
                    ]
                )
                completion(true, error)
            }

        case .sharingAuthorized:
            // Có quyền → truy vấn
            completion(true, NSError())

        @unknown default:
            let error = NSError(
                domain: "HealthAuth",
                code: 5,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Trạng thái quyền không xác định."
                ]
            )
            completion(false, error)
        }
    }
    // MARK: - Public: Fetch Step Count
    func fetchStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        guard
            let stepType = HKQuantityType.quantityType(
                forIdentifier: .stepCount
            )
        else {
            completion(
                .failure(
                    NSError(
                        domain: "HealthQuery",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey:
                                "Không thể tạo stepCount type."
                        ]
                    )
                )
            )
            return
        }

        let predicate = HKQuery.predicateForSamples(
            withStart: .startOfDay(),
            end: .nowDate(),
            options: .strictStartDate
        )

        let query = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { [weak self] _, result, error in
            guard let self = self else { return }

            if let error = error {
                self.checkPermissionForHealth(for: stepType) { permissionResult in
                    DispatchQueue.main.async {
                        switch permissionResult {
                        case .failure(let permissionError):
                            completion(.failure(permissionError))
                        case .success:
                            completion(.failure(error))
                        }
                    }
                }
                return
            }

            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                DispatchQueue.main.async {
                    completion(.success(steps))
                }
            } else {
                let noDataError = NSError(
                    domain: "HealthQuery",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Không có dữ liệu bước chân."
                    ]
                )
                DispatchQueue.main.async {
                    completion(.failure(noDataError))
                }
            }
        }

        healthStore.execute(query)
    }

    // MARK: - Private: Check Permission
    private func checkPermissionForHealth(
        for healthDataType: HKObjectType,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let status = healthStore.authorizationStatus(for: healthDataType)

        switch status {
        case .notDetermined:
            let error = NSError(
                domain: "HealthQuery",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Quyền truy cập HealthKit chưa được yêu cầu."
                ]
            )
            completion(.failure(error))

        case .sharingDenied:
            let error = NSError(
                domain: "HealthQuery",
                code: 3,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Người dùng đã từ chối quyền truy cập bước chân."
                ]
            )
            completion(.failure(error))

        case .sharingAuthorized:
            completion(.success(()))

        @unknown default:
            let error = NSError(
                domain: "HealthQuery",
                code: 4,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Trạng thái quyền truy cập không xác định."
                ]
            )
            completion(.failure(error))
        }
    }
}
